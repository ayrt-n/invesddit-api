class AddUniquenessConstraintToVotes < ActiveRecord::Migration[7.0]
  def change
    add_index :votes, [:account_id, :votable_id, :votable_type], unique: true
  end
end
