class Membership < ApplicationRecord
  belongs_to :community, counter_cache: true
  belongs_to :account

  validates :account, uniqueness: { scope: [:community_id], message: 'is already a member' }

  enum :role, { member: 1, admin: 2 }
end
