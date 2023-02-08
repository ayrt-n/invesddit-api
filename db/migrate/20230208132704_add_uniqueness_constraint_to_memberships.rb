class AddUniquenessConstraintToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_index :memberships, [:account_id, :community_id], unique: true
  end
end
