require 'rails_helper'

RSpec.describe '/PATCH notifications/:id', type: :request do
  it 'updates the notification' do
    notification = create(:notification)
    account = notification.account

    login_with_api(account)
    patch api_v1_notification_path(notification), headers: {
      Authorization: response['Authorization']
    }, params: { notification: { read: true } }, as: :json

    notification.reload

    expect(response.status).to eq(204)
    expect(notification.read).to be true
  end

  context 'when no authorization header' do
    it 'returns 401' do
      notification = create(:notification)

      patch api_v1_notification_path(notification), params: {
        notification: { read: true }
      }, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when other account tries to update another users notification' do
    it 'returns 401' do
      notification = create(:notification)
      account = create(:account)

      login_with_api(account)
      patch api_v1_notification_path(notification), headers: {
        Authorization: response['Authorization']
      }, params: { notification: { read: true } }, as: :json

      notification.reload

      expect(response.status).to eq(401)
    end
  end
end