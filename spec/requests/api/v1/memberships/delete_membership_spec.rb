require 'rails_helper'

RSpec.describe '/DELETE memberships/:id', type: :request do
  it 'deletes membership' do
    membership = create(:membership)
    membership_url = "/api/v1/memberships/#{membership.id}"

    login_with_api(membership.account)
    delete membership_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    record = Membership.find_by(id: membership.id)

    expect(response.status).to eq(204)
    expect(record).to be_nil
  end

  context 'when trying to delete another users membership' do
    it 'returns status 401 with errors' do
      other_account = create(:account)
      membership = create(:membership)
      membership_url = "/api/v1/memberships/#{membership.id}"

      login_with_api(other_account)
      delete membership_url, headers: {
        Authorization: response['Authorization']
      }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
