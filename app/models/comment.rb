class Comment < ApplicationRecord
  enum status: { published: 'published', deleted: 'deleted' }

  belongs_to :post, counter_cache: true
  belongs_to :account

  has_many :replies, class_name: 'Comment',
                     foreign_key: 'reply_id'

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

  private

  # If upvotes/downvotes changed, will need to update cached ranking
  def ranking_update_required?
    cached_upvotes_changed? || cached_downvotes_changed?
  end
end
