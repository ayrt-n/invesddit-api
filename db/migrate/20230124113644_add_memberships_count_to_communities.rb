class AddMembershipsCountToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :memberships_count, :integer
  end
end
