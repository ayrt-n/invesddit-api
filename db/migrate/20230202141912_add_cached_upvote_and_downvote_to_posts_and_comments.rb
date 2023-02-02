class AddCachedUpvoteAndDownvoteToPostsAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cached_upvotes, :integer, default: 0
    add_column :posts, :cached_downvotes, :integer, default: 0

    add_column :comments, :cached_upvotes, :integer, default: 0
    add_column :comments, :cached_downvotes, :integer, default: 0
  end
end
