class AddTimestampsToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :created_at, :datetime, null: false
  end
end
