require 'rails_helper'

RSpec.describe '/PATCH communities', type: :request do
  let(:account) { create(:account, :verified) }

  it 'updates the community' do
    # Create account and community
    account = create(:account)
    community = create(:community, title: nil)
    community_url = "/api/v1/communities/#{community.sub_dir}"

    # Set account as admin of community
    create(:membership, :is_admin, account: account, community: community)

    login_with_api(account)
    patch community_url, headers: {
      Authorization: response['Authorization']
    }, params: { title: community.sub_dir }, as: :json

    community.reload

    expect(response.status).to eq(204)
    expect(community.title).to eq(community.sub_dir)
  end

  context 'when non-admin tries to update' do
    it 'returns status 401 with errors' do
      account = create(:account)
      community = create(:community, title: nil)
      community_url = "/api/v1/communities/#{community.sub_dir}"

      login_with_api(account)
      patch community_url, headers: {
        Authorization: response['Authorization']
      }, params: { title: community.sub_dir }, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when authorization header is missing' do
    it 'return status 401 with errors' do
      community = create(:community, title: nil)
      community_url = "/api/v1/communities/#{community.sub_dir}"

      patch community_url, params: { title: community.sub_dir }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
