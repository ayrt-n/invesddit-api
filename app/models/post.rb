class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community

  has_many :comments, as: :commentable

  include Votable
  has_many :votes, as: :votable

  before_update :update_hot_ranking

  def update_hot_ranking
    self.cached_hot_rank = hot_rank if cached_score_changed?
  end

  validates :title, presence: true

  # Filtering Scopes
  scope :filter_by_community, ->(community) { joins(:community).where('communities.sub_dir = ?', community) }

  # Ordering Scopes
  scope :sort_by_hot, -> { order(cached_hot_rank: :desc) }
  scope :sort_by_new, -> { order(created_at: :desc) }
  scope :sort_by_top, -> { order(cached_score: :desc) }
end
