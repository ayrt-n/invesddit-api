class AddStatusToPosts < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE posts_status AS ENUM ('published', 'deleted');
    SQL
    add_column :posts, :status, :posts_status, default: 'published'
  end

  def down
    remove_column :posts, :status
    execute <<-SQL
      DROP TYPE posts_status;
    SQL
  end
end
