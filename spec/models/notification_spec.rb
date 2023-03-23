require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'after create' do
    it 'increments accounts unread notification count' do
      account = create(:account)
      create(:notification, account:)
      create(:notification, account:)

      account.reload

      expect(account.unread_notification_count).to eq(2)
    end
  end

  context 'after update' do
    it 'decrements accounts unread notification count if read' do
      account = create(:account)
      notification = create(:notification, account:)

      notification.update(read: true)
      account.reload

      expect(account.unread_notification_count).to eq(0)
    end

    it 'increments accounts unread notification count if unread' do
      account = create(:account)
      notification = create(:notification, account:, read: true)

      notification.update(read: false)
      account.reload

      expect(account.unread_notification_count).to eq(1)
    end
  end

  context 'after destroy' do
    it 'decrements accounts unread notification count if unread' do
      account = create(:account)
      notification = create(:notification, account:)
      create(:notification, account:)

      notification.destroy
      account.reload

      expect(account.unread_notification_count).to eq(1)
    end

    it 'does not decrement accounts unread notification count if read' do
      account = create(:account)
      notification = create(:notification, account:, read: true)
      create(:notification, account:)

      notification.destroy
      account.reload

      expect(account.unread_notification_count).to eq(1)
    end
  end
end
