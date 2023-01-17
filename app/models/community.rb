class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :sub_dir

  validates :sub_dir, presence: true, uniqueness: true
end
