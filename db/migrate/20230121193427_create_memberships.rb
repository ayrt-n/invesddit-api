class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.references :account
      t.references :community
      t.integer :role, default: 1

      t.timestamps
    end
  end
end
