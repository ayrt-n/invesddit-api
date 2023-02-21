require 'rails_helper'

RSpec.describe '/POST communities/:id/media_posts', type: :request do
  let(:account) { create(:account, :verified) }
  let(:community) { create(:community) }

  it 'creates a link post' do
    post_url = "/api/v1/communities/#{community.sub_dir}/media_posts"

    login_with_api(account)
    post post_url, headers: {
      Authorization: response['Authorization']
    }, params: { post: { image: fixture_file_upload('test.jpeg', 'image/jpeg'), title: 'Test' } }

    post = Post.last

    expect(response.status).to eq(200)
    expect(post.title).to eq('Test')
    expect(post.type).to eq('MediaPost')
    expect(post.image.attached?).to be true
  end

  context 'when authorization is missing' do
    it 'returns status 401 with errors' do
      post_url = "/api/v1/communities/#{community.sub_dir}/media_posts"

      post post_url, params: { post: { image: fixture_file_upload('test.jpeg', 'image/jpeg'), title: 'Test' } }

      expect(response.status).to eq(401)
    end
  end

  context 'when attributes invalid' do
    it 'returns status 422 with errors' do
      post_url = "/api/v1/communities/#{community.sub_dir}/media_posts"

      login_with_api(account)
      post post_url, headers: {
        Authorization: response['Authorization']
      }, params: { post: { title: 'Test' } }

      expect(response.status).to eq(422)
    end
  end
end
