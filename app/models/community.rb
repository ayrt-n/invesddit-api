class Community < ApplicationRecord
  # Extend friendly id
  # Allows us to work with communities sub_dir attribute similarly to an id
  extend FriendlyId
  friendly_id :sub_dir

  # Pagination related functionality
  extend Paginator
  paginates_per_page 10

  # Community Associations and validations
  has_many :posts
  has_many :memberships, dependent: :destroy
  has_many :admins, -> { where(memberships: { role: 'admin' }) }, through: :memberships, source: :account
  has_many :members, through: :memberships, source: :account

  has_one_attached :avatar
  has_one_attached :banner

  validates :sub_dir, presence: true,
                      uniqueness: true,
                      length: { maximum: 20 }

  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 500 }

  # Receives account, returns the role ('admin', 'member') or nil
  # If nil provided, returns nil
  def role(account)
    memberships.find_by(account:)&.role
  end
end
