require 'rails_helper'

RSpec.describe '/GET search', type: :request do
  context 'when search results found' do
    it 'returns list of relevant posts, communities, and accounts' do
      search_string = 'search'
      search_url = "/api/v1/search/?q=#{search_string}"

      # Posts which should be returned
      p1 = create(:text_post, title: 'Testing search functionality')
      p2 = create(:media_post, title: 'SEARCH results')
      p3 = create(:link_post, title: 'Recent research link')

      # Posts which should not be returned
      p4 = create(:post, title: 'Mispelled serch')

      # Communities which should be returned
      c1 = create(:community, sub_dir: 'GoogleSearch')
      c2 = create(:community, sub_dir: 'Research')

      # Communities which should not be returned
      c3 = create(:community, sub_dir: 'googleSRCH')

      # Users which should be returned
      a1 = create(:account, username: 'Searching4truth')

      # Users which should not be returned
      a2 = create(:account, username: 'srchin4truth')
      a3 = create(:account, username: 'truthsrcher')

      get search_url, as: :json

      p_results = json['data']['posts'].map { |d| d['id'] }
      c_results = json['data']['communities'].map { |d| d['id'] }
      a_results = json['data']['accounts'].map { |d| d['id'] }

      expect(response.status).to eq(200)

      expect(p_results).to include(p1.id, p2.id, p3.id)
      expect(p_results).not_to include(p4.id)

      expect(c_results).to include(c1.id, c2.id)
      expect(c_results).not_to include(c3.id)

      expect(a_results).to include(a1.id)
      expect(a_results).not_to include(a2.id, a3.id)
    end
  end
end
