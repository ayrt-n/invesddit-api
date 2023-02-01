class AddCachedHotRankToPostsAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cached_hot_rank, :float, default: 0
    add_column :comments, :cached_hot_rank, :float, default: 0
  end
end
