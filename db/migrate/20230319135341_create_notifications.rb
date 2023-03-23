class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :account, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true
      t.string :message
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
