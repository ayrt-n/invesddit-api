class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :sub_dir

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
end
