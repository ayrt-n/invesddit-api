class RemoveUniqueConstraintFromMemberships < ActiveRecord::Migration[7.0]
  def change
    remove_index :memberships, [:account_id, :community_id], unique: true
    add_index :memberships, [:account_id, :community_id]
  end
end
