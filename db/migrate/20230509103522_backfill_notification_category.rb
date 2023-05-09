class BackfillNotificationCategory < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    Notification.find_each do |notification|
      if notification.message.include?('replied to your post')
        notification.comment!
      else
        notification.reply!
      end

      sleep(0.01) # Throttle
    end
  end
end
