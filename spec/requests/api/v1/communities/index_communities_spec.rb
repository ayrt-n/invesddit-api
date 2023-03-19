require 'rails_helper'

RSpec.describe '/GET communities', type: :request do
  it 'returns list of all communities' do
    communities_url = '/api/v1/communities'
    3.times { create(:community) }

    get communities_url, as: :json

    expect(response.status).to eq(200)
    expect(json['data'].length).to be(3)
  end

  context 'when search param provided' do
    it 'returns list of communities which sub_dir matches search' do
      search_string = 'go'
      search_url = "/api/v1/communities/?q=#{search_string}"

      # Communities which should be returned
      c1 = create(:community, sub_dir: 'GOOG')
      c2 = create(:community, sub_dir: 'GO')
      c3 = create(:community, sub_dir: 'LuxuryGoods')

      # Communities which should not be returned
      c4 = create(:community, sub_dir: 'GLOW')
      c5 = create(:community, sub_dir: 'GroceryStocks')

      get search_url, as: :json

      results = json['data'].map { |d| d['id'] }

      expect(response.status).to eq(200)
      expect(results).to include(c1.id, c2.id, c3.id)
      expect(results).not_to include(c4.id, c5.id)
    end
  end
end
