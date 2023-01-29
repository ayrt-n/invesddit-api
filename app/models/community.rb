class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :sub_dir

  has_many :posts
  has_many :memberships
  has_many :admins, -> { where(memberships: { role: 'admin' }) }, through: :memberships, source: :account

  validates :sub_dir, presence: true,
                      uniqueness: true,
                      length: { maximum: 20 }

  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 500 }

  def admin_ids
    admins.ids
  end
end
