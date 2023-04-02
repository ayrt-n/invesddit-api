require 'rails_helper'

RSpec.describe '/GET search/accounts', type: :request do
  before do
    search_string = 'search'
    @search_url = "/api/v1/search/accounts?q=#{search_string}"
  end

  it 'returns list of relevant accounts' do
    # Posts which should be returned
    a1 = create(:account, username: 'searcher23')
    a2 = create(:account, username: '99search')

    # Posts which should not be returned
    a3 = create(:account, username: 'Mispelled_serch')

    get @search_url, as: :json

    results = json['data'].map { |d| d['id'] }

    expect(response.status).to eq(200)

    expect(results).to include(a1.id, a2.id)
    expect(results).not_to include(a3.id)
  end

  it 'returns empty array if no results found' do
    create(:account, username: 'no_match')

    get @search_url, as: :json

    expect(response.status).to eq(200)
    expect(json['data']).to eq([])
  end
end
