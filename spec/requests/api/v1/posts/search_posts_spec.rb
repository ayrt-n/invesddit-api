require 'rails_helper'

RSpec.describe '/GET search/posts', type: :request do
  before do
    search_string = 'search'
    @search_url = "/api/v1/search/posts?q=#{search_string}"
  end

  it 'returns list of relevant posts' do
    # Posts which should be returned
    p1 = create(:text_post, title: 'Testing search functionality')
    p2 = create(:media_post, title: 'SEARCH results')
    p3 = create(:link_post, title: 'Recent research link')

    # Posts which should not be returned
    p4 = create(:post, title: 'Mispelled serch')

    get @search_url, as: :json

    results = json['data'].map { |d| d['id'] }

    expect(response.status).to eq(200)

    expect(results).to include(p1.id, p2.id, p3.id)
    expect(results).not_to include(p4.id)
  end

  it 'returns empty array if no results found' do
    create(:post, title: 'No match')

    get @search_url, as: :json

    expect(response.status).to eq(200)
    expect(json['data']).to eq([])
  end
end
