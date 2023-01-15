require 'rails_helper'

RSpec.describe '/POST communities', type: :request do
  let(:verified_account) { create(:account, :verified) }
  let(:unverified_account) { create(:account) }
  let(:community) { create(:community) }
  let(:communities_url) { '/api/v1/communities' }

  it 'creates a new community' do
    login_with_api(verified_account)

    post communities_url, headers: {
      Authorization: response['Authorization']
    }, params: community, as: :json

    expect(response.status).to eq(201)
    expect(json['sub_dir']).to eq(community.sub_dir)
  end
end
