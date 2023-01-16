require 'rails_helper'

RSpec.describe '/GET communities', type: :request do
  it 'returns list of all communities' do
    communities_url = '/api/v1/communities'
    3.times { create(:community) }

    get communities_url, as: :json

    expect(response.status).to eq(200)
    expect(json['communities'].length).to be(3)
  end
end

RSpec.describe '/GET communities/c/:sub_dir', type: :request do
  it 'returns the community' do
    community = create(:community)
    community_url = "/api/v1/communities/#{community.sub_dir}"

    get community_url, as: :json

    expect(response.status).to eq(200)
    expect(json['community']['sub_dir']).to eq(community.sub_dir)
  end
end
