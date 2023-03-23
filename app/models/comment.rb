class Comment < ApplicationRecord
  enum status: { published: 'published', deleted: 'deleted' }

  belongs_to :post, counter_cache: true
  belongs_to :account

  has_many :replies, class_name: 'Comment', foreign_key: 'reply_id'
  belongs_to :comment, foreign_key: 'reply_id', optional: true

  include Votable
  has_many :votes, as: :votable, dependent: :destroy

  before_save :update_cached_rankings, if: :ranking_update_required?

  def update_cached_rankings
    rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

    self.cached_score = rank.score
    self.cached_hot_rank = rank.hot_rank
    self.cached_confidence_score = rank.confidence_score
  end

  # Ordering Scopes
  scope :sort_by_best, -> { order(cached_confidence_score: :desc) }
  scope :sort_by_hot, -> { order(cached_hot_rank: :desc) }
  scope :sort_by_new, -> { order(created_at: :desc) }
  scope :sort_by_top, -> { order(cached_score: :desc) }

  validates :body, presence: true

  include Notifiable
  after_create :create_notifications

  # After create, create comment notifications
  def create_notifications
    create_reply_notification
    create_post_notification
  end

  # If the comment is a reply to another comment, notify the comment author this is in response to
  def create_reply_notification
    # Do not notify if comment is not published or the comment author is the account replying
    return unless comment&.published?
    return if comment.account == account

    notify(
      notifiable: self,
      account: comment.account,
      message: "u/#{account.username} replied to your comment in c/#{post.community.sub_dir}"
    )
  end

  # Notify the original post author of a comment
  def create_post_notification
    # Do not notify if post is not published or the post author is the account repling
    return unless post&.published?
    return if post.account == account

    notify(
      notifiable: self,
      account: post.account,
      message: "u/#{account.username} replied to your post in c/#{post.community.sub_dir}"
    )
  end

  private

  # If upvotes/downvotes changed, will need to update cached ranking
  def ranking_update_required?
    cached_upvotes_changed? || cached_downvotes_changed?
  end
end
