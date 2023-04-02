require 'rails_helper'

RSpec.describe '/GET search/posts', type: :request do
  before do
    search_string = 'search'
    @search_url = "/api/v1/search/communities?q=#{search_string}"
  end

  it 'returns list of relevant posts if results exist' do
    # Posts which should be returned
    c1 = create(:community, sub_dir: 'GOOGsearch')
    c2 = create(:community, sub_dir: 'StockReSEARCH')

    # Posts which should not be returned
    c3 = create(:community, sub_dir: 'serch')

    get @search_url, as: :json

    results = json['data'].map { |d| d['id'] }

    expect(response.status).to eq(200)

    expect(results).to include(c1.id, c2.id)
    expect(results).not_to include(c3.id)
  end

  it 'returns empty array if no results found' do
    create(:community, sub_dir: 'nomatch')

    get @search_url, as: :json

    expect(response.status).to eq(200)
    expect(json['data']).to eq([])
  end
end
