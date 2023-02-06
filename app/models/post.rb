class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community

  has_many :comments, as: :commentable

  include Votable
  has_many :votes, as: :votable

  before_save :update_cached_rankings, if: :ranking_update_required?

  def update_cached_rankings
    rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

    self.cached_score = rank.score
    self.cached_hot_rank = rank.hot_rank
    self.cached_confidence_score = rank.confidence_score
  end

  validates :title, presence: true

  # Filtering Scopes
  scope :filter_by_community, ->(community) { joins(:community).where('communities.sub_dir = ?', community) }

  # Ordering Scopes
  scope :sort_by_hot, -> { order(cached_hot_rank: :desc) }
  scope :sort_by_new, -> { order(created_at: :desc) }
  scope :sort_by_top, -> { order(cached_score: :desc) }

  private

  # If record is new, or upvotes/downvotes changed, will need to update cached ranking
  def ranking_update_required?
    new_record? || cached_upvotes_changed? || cached_downvotes_changed?
  end
end
