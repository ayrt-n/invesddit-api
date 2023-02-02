class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :account

  has_many :comments, as: :commentable

  include Votable
  has_many :votes, as: :votable

  before_save :update_cached_rankings, if: :cached_upvotes_changed? || :cached_downvotes_changed?

  def update_cached_rankings
    rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

    self.cached_score = rank.score
    self.cached_hot_rank = rank.hot_rank
    self.cached_confidence_score = rank.confidence_score
  end

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
