class DropMessageFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :message, :string
  end
end
