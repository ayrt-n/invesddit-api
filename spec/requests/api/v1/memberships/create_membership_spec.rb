require 'rails_helper'

RSpec.describe '/POST communities/:sub_dir/memberships', type: :request do
  it 'creates membership for current account and community' do
    account = create(:account)
    community = create(:community)
    membership_url = "/api/v1/communities/#{community.sub_dir}/memberships"

    login_with_api(account)
    post membership_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    membership = Membership.last

    expect(response.status).to eq(204)
    expect(membership.community).to eq(community)
    expect(membership.account).to eq(account)
  end

  context 'when authorization header is missing' do
    it 'returns status 401 and errors' do
      community = create(:community)
      membership_url = "/api/v1/communities/#{community.sub_dir}/memberships"

      post membership_url, as: :json

      expect(response.status).to eq(401)
    end
  end
end
