require 'rails_helper'

RSpec.describe '/GET communities/:sub_dir', type: :request do
  it 'returns the community' do
    community = create(:community)
    community_url = "/api/v1/communities/#{community.sub_dir}"

    get community_url, as: :json

    expect(response.status).to eq(200)
    expect(json['community']['sub_dir']).to eq(community.sub_dir)
  end
end
