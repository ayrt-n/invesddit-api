class Membership < ApplicationRecord
  belongs_to :community, counter_cache: true
  belongs_to :account

  enum :role, { member: 1, admin: 2 }
end
