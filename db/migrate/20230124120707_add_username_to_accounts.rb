class AddUsernameToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :username, :string
    add_index :accounts, :username
  end
end
