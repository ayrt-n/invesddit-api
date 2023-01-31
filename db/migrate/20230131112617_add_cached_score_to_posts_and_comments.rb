class AddCachedScoreToPostsAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cached_score, :integer, default: 0, null: false
    add_column :comments, :cached_score, :integer, default: 0, null: false
  end
end
