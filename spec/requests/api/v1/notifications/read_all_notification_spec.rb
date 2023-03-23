require 'rails_helper'

RSpec.describe '/PATCH notifications' do
  it 'updates all unread notifications to read' do
    account = create(:account)
    3.times { create(:notification, account:) }

    login_with_api(account)
    patch '/api/v1/notifications', headers: {
      Authorization: response['Authorization']
    }, as: :json

    account.reload
    noti_status = account.notifications.map(&:read)

    expect(response.status).to eq(204)
    expect(account.unread_notification_count).to eq(0)
    expect(noti_status.length).to eq(3)
    expect(noti_status).to all be true
  end

  context 'when no authorization header' do
    it 'returns 401' do
      account = create(:account)
      create(:notification, account:)

      patch '/api/v1/notifications', as: :json

      expect(response.status).to eq(401)
    end
  end
end
