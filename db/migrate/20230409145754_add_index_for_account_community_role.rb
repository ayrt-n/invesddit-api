class AddIndexForAccountCommunityRole < ActiveRecord::Migration[7.0]
  def change
    add_index :memberships, %i[account_id community_id role], unique: true
  end
end
