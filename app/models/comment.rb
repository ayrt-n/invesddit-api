class Comment < ApplicationRecord
  enum status: { published: 'published', deleted: 'deleted' }

  belongs_to :post, counter_cache: true
  belongs_to :account
  belongs_to :comment, foreign_key: 'reply_id', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: 'reply_id'
  has_many :votes, as: :votable, dependent: :destroy
  has_many :notifications, as: :notifiable

  validates :body, presence: true

  # Include Votable related functionality
  include Votable

  # Ordering Scopes
  scope :sort_by_new, -> { order(created_at: :desc, id: :desc) }

  # Notification related functionality
  include Notifiable
  after_create :create_notifications

  # After comment created, create related comment notifications
  def create_notifications
    create_reply_notification
    create_post_notification
  end

  # Soft delete method
  # Update comment to be soft deleted and run necessary callbacks / side effects
  def soft_delete!
    # Set current comment.status to deleted
    deleted!

    # Destroy associated notifications
    notifications.destroy_all
  end

  # Returns comment content, body by default if comment is published
  # If comment is deleted, will return nil instead
  def content
    deleted? ? '[removed]' : body
  end

  private

  # If the comment is a reply to another comment, notify the comment author this is in response to
  def create_reply_notification
    # Do not notify if comment is not published, comment is in reply to self,
    # or if the comment this is in response to is also the post author (in
    # which case they will receive a notification from that)
    return if !comment&.published? || comment.account == account || comment.post.account == comment.account

    notify(
      notifiable: self,
      account: comment.account
    )
  end

  # Notify the original post author of a comment
  def create_post_notification
    # Do not notify if post is not published or the post author is the account repling
    return unless post&.published?
    return if post.account == account

    notify(
      notifiable: self,
      account: post.account
    )
  end
end
