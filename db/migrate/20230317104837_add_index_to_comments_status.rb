class AddIndexToCommentsStatus < ActiveRecord::Migration[7.0]
  def change
    add_index :comments, :status
  end
end
