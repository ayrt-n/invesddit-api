class AddNullFalseToCommentsAccountId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :comments, :account_id, false
  end
end
