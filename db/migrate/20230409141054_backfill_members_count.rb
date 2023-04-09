class BackfillMembersCount < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    Community.find_each do |community|
      members = community.memberships.where(role: 1).count
      community.update(members_count: members)
      sleep(0.01) # Throttle
    end
  end
end
