class AddNotificationCategoryToNotifications < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE notification_category AS ENUM ('comment', 'reply');
    SQL
    add_column :notifications, :category, :notification_category
  end

  def down
    remove_column :notifications, :category
    execute <<-SQL
      DROP TYPE notification_category;
    SQL
  end
end
