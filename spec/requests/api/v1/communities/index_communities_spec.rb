require 'rails_helper'

RSpec.describe '/GET communities', type: :request do
  it 'returns list of all communities' do
    communities_url = '/api/v1/communities'
    3.times { create(:community) }

    get communities_url, as: :json

    expect(response.status).to eq(200)
    expect(json['data'].length).to be(3)
  end
end
