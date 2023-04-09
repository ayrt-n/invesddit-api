class Membership < ApplicationRecord
  belongs_to :community, counter_cache: true
  belongs_to :account

  validates :account,
            uniqueness: {
              scope: %i[community_id role],
              message: lambda { |object, _data|
                object.role == 'member' ? 'is already a member' : 'is already an admin'
              }
            }

  enum :role, { member: 1, admin: 2 }
end
