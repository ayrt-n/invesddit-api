class Community < ApplicationRecord
  # Extend friendly id
  # Allows us to work with communities sub_dir attribute similarly to an id
  extend FriendlyId
  friendly_id :sub_dir

  # Pagination related functionality - default communities per page is 10
  extend Paginator
  paginates_per_page 10

  # Community Associations and validations
  has_many :posts
  has_many :memberships, dependent: :destroy
  has_many :admins, -> { where(memberships: { role: 'admin' }) }, through: :memberships, source: :account
  has_many :members, -> { where(memberships: { role: 'member' }) }, through: :memberships, source: :account

  has_one_attached :avatar
  has_one_attached :banner

  validates :avatar, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 2.megabytes }

  validates :banner, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 5.megabytes }

  validates :sub_dir, presence: true,
                      uniqueness: true,
                      length: { maximum: 20 },
                      format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }

  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 500 }

  # Search Scope
  scope :search, lambda { |q|
    where('sub_dir ILIKE ?', "%#{Community.sanitize_sql_like(q)}%")
      .with_attached_avatar
      .with_attached_banner
  }

  # Receives account, returns array of the accounts roles (e.g., 'admin', 'member') or empty array
  def roles(account)
    memberships.where(account:)&.pluck(:role) || []
  end
end
