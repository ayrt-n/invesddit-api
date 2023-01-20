class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.integer :vote
      t.references :account, null: false, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
