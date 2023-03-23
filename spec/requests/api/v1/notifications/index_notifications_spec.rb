require 'rails_helper'

RSpec.describe '/GET notifications', type: :request do
  it 'returns all notifications for the current user' do
    # Current user notifications
    account = create(:account)
    3.times { create(:notification, account:) }

    # Notifications not for current user
    2.times { create(:notification) }

    login_with_api(account)
    get api_v1_notifications_path, headers: {
      Authorization: response['Authorization']
    }, as: :json

    expect(response.status).to eq(200)
    expect(json['data'].length).to eq(3)
  end

  context 'when no authorization header included' do
    it 'returns 401' do
      3.times { create(:notification) }

      get api_v1_notifications_path, as: :json
  
      expect(response.status).to eq(401)
    end
  end
end
