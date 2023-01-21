class Membership < ApplicationRecord
  belongs_to :community
  belongs_to :account

  enum :role, { member: 1, admin: 2 }
end
