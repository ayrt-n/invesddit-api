class Post < ApplicationRecord
  enum status: { published: 'published', deleted: 'deleted' }

  belongs_to :account
  belongs_to :community
  has_one_attached :image, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, presence: true, length: { maximum: 300 }
  validates :type, presence: true, inclusion: { in: %w[TextPost LinkPost MediaPost] }

  # Eager load associations needed to display feed and avoid n+1 problem
  scope :include_feed_associations, lambda {
    includes(
      account: [{ avatar_attachment: [:blob] }],
      community: [{ avatar_attachment: [:blob] }, { banner_attachment: [:blob] }]
    )
      .with_attached_image
  }

  # Filtering Scopes
  scope :filter_by_communities, ->(communities) { joins(:community).where({ communities: { sub_dir: communities } }) }
  scope :all_communities, -> { unscope(where: 'communities.sub_dir') }
  scope :filter_by_account, ->(account) { where({ account: }) }

  # Ordering Scopes
  scope :sort_by_best, -> { order(cached_confidence_score: :desc, id: :desc) }
  scope :sort_by_hot, -> { order(cached_hot_rank: :desc, id: :desc) }
  scope :sort_by_new, -> { order(created_at: :desc, id: :desc) }
  scope :sort_by_top, -> { order(cached_score: :desc, id: :desc) }

  # Pagination related functionality
  extend Paginator
  paginates_per_page 25

  # Update cached rankings
  include Votable
  before_save :update_cached_rankings, if: :ranking_update_required?

  def update_cached_rankings
    rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

    self.cached_score = rank.score
    self.cached_hot_rank = rank.hot_rank
    self.cached_confidence_score = rank.confidence_score
  end

  # Return the post author, e.g., the account it belongs to if the post is published
  # If post is deleted, will return nil instead
  def author
    deleted? ? nil : account
  end

  private

  # If record upvotes/downvotes changed, will need to update cached ranking
  def ranking_update_required?
    cached_upvotes_changed? || cached_downvotes_changed?
  end
end
