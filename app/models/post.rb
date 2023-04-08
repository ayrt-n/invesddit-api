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
  scope :sort_by_new, -> { order(created_at: :desc, id: :desc) }

  # Search Scope
  scope :search, lambda { |q|
    where('title ILIKE ?', "%#{Post.sanitize_sql_like(q)}%")
      .published
      .include_feed_associations
  }

  # Pagination related functionality
  extend Paginator
  paginates_per_page 25

  # Include Votable related functionality
  include Votable

  # Return the post author, e.g., the account it belongs to if the post is published
  # If post is deleted, will return nil instead
  def author
    deleted? ? nil : account
  end

  # Returns post content, body by default if post is published
  # If post is deleted, will return nil instead
  def content
    deleted? ? nil : body
  end
end
