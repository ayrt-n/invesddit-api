require 'rails_helper'

RSpec.describe '/POST communities/:id/media_posts', type: :request do
  let(:account) { create(:account, :verified) }
  let(:community) { create(:community) }

  it 'creates a link post' do
    post_url = "/api/v1/communities/#{community.sub_dir}/media_posts"
    post_params = build(:media_post)

    login_with_api(account)
    post post_url, headers: {
      Authorization: response['Authorization']
    }, params: post_params, as: :json

    expect(response.status).to eq(200)
    expect(Post.last.title).to eq(post_params.title)
    expect(Post.last.type).to eq(post_params.type)
  end

  context 'when authorization is missing' do
    it 'returns status 401 with errors' do
      post_url = "/api/v1/communities/#{community.sub_dir}/media_posts"
      post_params = build(:media_post)

      post post_url, params: post_params, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when attributes invalid' do
    it 'returns status 422 with errors' do
      post_url = "/api/v1/communities/#{community.sub_dir}/media_posts"
      post_params = build(:media_post, title: nil)

      login_with_api(account)
      post post_url, headers: {
        Authorization: response['Authorization']
      }, params: post_params, as: :json

      expect(response.status).to eq(422)
    end
  end
end
