class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :account

  has_many :comments, as: :commentable

  has_many :votes, as: :votable
  include Votable

  validates :body, presence: true

  # Custom counter cache for Post model
  after_create :increment_count
  after_destroy :decrement_count

  def increment_count
    parent = find_root_post
    # Increment the comment count
    parent.increment!(:comments_count)
  end

  def decrement_count
    parent = find_root_post
    # Decrement the comment count
    parent.decrement!(:comments_count)
  end

  private

  # Polymorphic comment model allows comment to belong to either a post or a comment
  # Method to find the root post a comment belongs to, returns the Post
  def find_root_post
    # Set parent to commentable
    parent = commentable
    # Continue moving up the associations until the parent is the root post
    parent = parent.commentable until parent.is_a? Post

    parent
  end
end
