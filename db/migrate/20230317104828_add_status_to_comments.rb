class AddStatusToComments < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE comments_status AS ENUM ('published', 'deleted');
    SQL
    add_column :comments, :status, :comments_status, default: 'published'
  end

  def down
    remove_column :comments, :status
    execute <<-SQL
      DROP TYPE comments_status;
    SQL
  end
end
