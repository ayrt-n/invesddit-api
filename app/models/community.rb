class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :sub_dir

  validates :sub_dir, presence: true,
                      uniqueness: true,
                      length: { maximum: 20 }

  validates :title, length: { maximum: 20 }
  validates :description, length: { maximum: 140 }
end
