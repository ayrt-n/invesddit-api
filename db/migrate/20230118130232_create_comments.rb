class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :account
      t.references :post, null: false, foreign_key: true
      t.references :reply, foreign_key: { to_table: :comments }

      t.timestamps
    end
  end
end
