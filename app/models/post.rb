class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community

  has_many :comments, as: :commentable

  include Votable
  has_many :votes, as: :votable

  before_save :update_cached_rankings, if: :cached_upvotes_changed? || :cached_downvotes_changed?

  def update_cached_rankings
    rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

    self.cached_score = rank.score
    self.cached_hot_rank = rank.hot_rank
  end

  validates :title, presence: true

  # Filtering Scopes
  scope :filter_by_community, ->(community) { joins(:community).where('communities.sub_dir = ?', community) }

  # Ordering Scopes
  scope :sort_by_hot, -> { order(cached_hot_rank: :desc) }
  scope :sort_by_new, -> { order(created_at: :desc) }
  scope :sort_by_top, -> { order(cached_score: :desc) }
end
