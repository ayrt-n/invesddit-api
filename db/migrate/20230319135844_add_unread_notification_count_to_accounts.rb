class AddUnreadNotificationCountToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :unread_notification_count, :integer, default: 0, null: false
  end
end
