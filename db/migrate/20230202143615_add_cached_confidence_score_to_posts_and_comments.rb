class AddCachedConfidenceScoreToPostsAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :cached_confidence_score, :float, default: 0
    add_column :comments, :cached_confidence_score, :float, default: 0
  end
end
