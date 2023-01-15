class Community < ApplicationRecord
  validates :sub_dir, presence: true
end
