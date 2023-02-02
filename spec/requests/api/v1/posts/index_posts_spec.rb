require 'rails_helper'

RSpec.describe '/GET posts', type: :request do
  it 'returns a list of all posts' do
    posts_url = '/api/v1/posts'
    3.times { create(:post) }

    get posts_url, as: :json

    expect(response.status).to eq(200)
    expect(json['data'].length).to eq(3)
  end

  context 'when community param included' do
    it 'only includes posts from the specified community' do
      community = create(:community)
      2.times { create(:post, community: community) }
      2.times { create(:post) }
      posts_url = "/api/v1/posts?community=#{community.sub_dir}"

      get posts_url, as: :json

      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(2)
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
