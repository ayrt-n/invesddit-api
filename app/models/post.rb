class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community
  has_one_attached :image, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 300 }
  validates :type, presence: true, inclusion: { in: %w[TextPost LinkPost MediaPost] }

  include Votable
  has_many :votes, as: :votable, dependent: :destroy

  before_save :update_cached_rankings, if: :ranking_update_required?

  def update_cached_rankings
    rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

    self.cached_score = rank.score
    self.cached_hot_rank = rank.hot_rank
    self.cached_confidence_score = rank.confidence_score
  end

  # Filtering Scopes
  scope :filter_by_communities, ->(communities) { joins(:community).where({ communities: { sub_dir: communities } }) }

  # Ordering Scopes
  scope :sort_by_best, -> { order(cached_confidence_score: :desc) }
  scope :sort_by_hot, -> { order(cached_hot_rank: :desc) }
  scope :sort_by_new, -> { order(created_at: :desc) }
  scope :sort_by_top, -> { order(cached_score: :desc) }

  private

  # If record upvotes/downvotes changed, will need to update cached ranking
  def ranking_update_required?
    cached_upvotes_changed? || cached_downvotes_changed?
  end
end
