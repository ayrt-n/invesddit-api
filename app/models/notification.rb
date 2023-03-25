class Notification < ApplicationRecord
  belongs_to :account
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :by_newest, -> { order(created_at: :desc) }

  extend Paginator
  paginates_per_page 10

  # On create, increment unread notification count unless it has been read
  # Would typically not see a notification created as read, but it is helpful for testing
  after_create :increment_unread_notification_count, unless: :read

  # On update, if the notification read status has been changed, update the unread notification count
  after_update :update_unread_notification_count, if: :saved_change_to_read?

  # On destroy, if the notification was unread, decrement the unread notification count
  after_destroy :decrement_unread_notification_count, unless: :read

  # Increase unread notification count by one
  def increment_unread_notification_count
    account.increment!(:unread_notification_count)
  end

  # Decrease unread notification count by one
  def decrement_unread_notification_count
    account.decrement!(:unread_notification_count)
  end

  # If status changed to read then decrement unread notifications (notifcation was marked as read)
  # Otherwise increment unread notifications (notification was marked as unread)
  def update_unread_notification_count
    read ? decrement_unread_notification_count : increment_unread_notification_count
  end
end
