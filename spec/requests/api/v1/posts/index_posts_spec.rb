require 'rails_helper'

RSpec.describe '/GET posts', type: :request do
  context 'when not logged in' do
    it 'returns a list of all published posts' do
      posts_url = '/api/v1/posts'
      3.times { create(:post) }
      2.times { create(:post, status: 'deleted') }

      get posts_url, as: :json

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(3)
    end

    it 'returns only community posts if community param is set' do
      community = create(:community)
      2.times { create(:post, community:) }
      2.times { create(:post) }
      community_posts_url = "/api/v1/communities/#{community.sub_dir}/posts"

      get community_posts_url, as: :json

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(2)
    end
  end

  context 'when logged in' do
    before do
      @c1 = create(:community)
      c2 = create(:community)
      c3 = create(:community)

      @p1 = create(:post, community: @c1)
      @p2 = create(:post, community: c2)
      @p3 = create(:post, community: c3)

      @account = create(:account)
      create(:membership, account: @account, community: @c1)
      create(:membership, account: @account, community: c2)
    end

    it 'only returns posts for the community the account is a member of' do
      posts_url = '/api/v1/posts'

      login_with_api(@account)
      get posts_url, headers: {
        Authorization: response['Authorization']
      }, as: :json

      posts_result = json['data'].map { |d| d['id'] }

      expect(response.status).to eq(200)
      expect(posts_result.length).to eq(2)
      expect(posts_result).to include(@p1.id)
      expect(posts_result).to include(@p2.id)
      expect(posts_result).not_to include(@p3.id)
    end

    it 'returns all posts if filter param set to all' do
      all_posts_url = '/api/v1/posts?filter=all'

      login_with_api(@account)
      get all_posts_url, headers: {
        Authorization: response['Authorization']
      }, as: :json

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(3)
    end

    it 'returns only community posts if community param is set' do
      community_posts_url = "/api/v1/communities/#{@c1.sub_dir}/posts"

      login_with_api(@account)
      get community_posts_url, headers: {
        Authorization: response['Authorization']
      }, as: :json

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(1)
    end
  end

  context 'when sort_by param included' do
    it 'sorts by posts hot rank by default' do
      p1 = create(:post, cached_hot_rank: 6)
      p2 = create(:post, cached_hot_rank: 30)
      p3 = create(:post, cached_hot_rank: 29)
      p4 = create(:post, cached_hot_rank: 3)

      posts_url = '/api/v1/posts'
      get posts_url, as: :json

      expect(json['data'][0]['id']).to eq(p2.id)
      expect(json['data'][1]['id']).to eq(p3.id)
      expect(json['data'][2]['id']).to eq(p1.id)
      expect(json['data'][3]['id']).to eq(p4.id)
    end

    it 'sorts by new if specified' do
      p1 = create(:post, cached_hot_rank: 6)
      p2 = create(:post, cached_hot_rank: 30)
      p3 = create(:post, cached_hot_rank: 29)
      p4 = create(:post, cached_hot_rank: 3)

      posts_url = '/api/v1/posts?sort_by=new'
      get posts_url, as: :json

      expect(json['data'][0]['id']).to eq(p4.id)
      expect(json['data'][1]['id']).to eq(p3.id)
      expect(json['data'][2]['id']).to eq(p2.id)
      expect(json['data'][3]['id']).to eq(p1.id)
    end

    it 'sorts by highest score if specified' do
      p1 = create(:post, cached_score: 6, cached_hot_rank: 3)
      p2 = create(:post, cached_score: 30, cached_hot_rank: 0)
      p3 = create(:post, cached_score: 29, cached_hot_rank: 1)
      p4 = create(:post, cached_score: 3, cached_hot_rank: 19)

      posts_url = '/api/v1/posts?sort_by=top'
      get posts_url, as: :json

      expect(json['data'][0]['id']).to eq(p2.id)
      expect(json['data'][1]['id']).to eq(p3.id)
      expect(json['data'][2]['id']).to eq(p1.id)
      expect(json['data'][3]['id']).to eq(p4.id)
    end
  end
end
