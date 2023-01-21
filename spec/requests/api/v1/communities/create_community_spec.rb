require 'rails_helper'

RSpec.describe '/POST communities', type: :request do
  let(:verified_account) { create(:account, :verified) }
  let(:unverified_account) { create(:account) }
  let(:community) { build(:community) }
  let(:communities_url) { '/api/v1/communities' }

  it 'creates a new community' do
    login_with_api(verified_account)

    post communities_url, headers: {
      Authorization: response['Authorization']
    }, params: community, as: :json

    expect(response.status).to eq(200)
    expect(json['data']['sub_dir']).to eq(community.sub_dir)
  end

  it 'sets the account used to create as an admin' do
    login_with_api(verified_account)

    post communities_url, headers: {
      Authorization: response['Authorization']
    }, params: community, as: :json

    record = Community.last

    expect(record.admin_ids).to include(verified_account.id)
  end

  context 'when attributes invalid' do
    it 'returns status 422 with errors' do
      login_with_api(verified_account)

      invalid_community = community
      invalid_community.sub_dir = nil

      post communities_url, headers: {
        Authorization: response['Authorization']
      }, params: invalid_community, as: :json

      expect(response.status).to eq(422)
    end
  end

  context 'when authorization header is missing' do
    it 'returns status 401 with errors' do
      post communities_url, params: community, as: :json

      expect(response.status).to eq(401)
    end
  end
end
