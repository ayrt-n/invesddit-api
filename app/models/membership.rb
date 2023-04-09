class Membership < ApplicationRecord
  belongs_to :community
  belongs_to :account

  validates :account,
            uniqueness: {
              scope: %i[community_id role],
              message: lambda { |object, _data|
                object.role == 'member' ? 'is already a member' : 'is already an admin'
              }
            }

  enum :role, { member: 1, admin: 2 }

  # Custom counter cache for members count
  after_create :increment_members_count, if: :member?
  after_destroy :decrement_members_count, if: :member?

  def increment_members_count
    community.increment!(:members_count)
  end

  def decrement_members_count
    community.decrement!(:members_count)
  end
end
