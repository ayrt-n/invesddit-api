class ReplaceMembershipsCountWithMembersCount < ActiveRecord::Migration[7.0]
  def change
    remove_column :communities, :memberships_count
    add_column :communities, :members_count, :integer, default: 0
  end
end
