require 'rails_helper'

RSpec.describe '/DELETE memberships/:id', type: :request do
  it 'deletes membership' do
    membership = create(:membership)
    membership_url = "/api/v1/communities/#{membership.community.sub_dir}/memberships"

    login_with_api(membership.account)
    delete membership_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    record = Membership.find_by(id: membership.id)

    expect(response.status).to eq(204)
    expect(record).to be_nil
  end
end
