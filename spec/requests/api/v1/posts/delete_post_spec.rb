require 'rails_helper'

RSpec.describe '/DELETE posts/:id', type: :request do
  it 'deletes the post' do
    account = create(:account, :verified)
    post = create(:post, account: account)
    post_url = "/api/v1/posts/#{post.id}"

    login_with_api(account)
    delete post_url, headers: { Authorization: response['Authorization'] }, as: :json
    result = Post.find(post.id)

    expect(response.status).to eq(204)
    expect(result.status).to eq('deleted')
  end

  context 'when authorization header is missing' do
    it 'returns status 401' do
      post = create(:post)
      post_url = "/api/v1/posts/#{post.id}"

      delete post_url, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when request not made by post author' do
    it 'returns status 401' do
      account = create(:account, :verified)
      post = create(:post)
      post_url = "/api/v1/posts/#{post.id}"

      login_with_api(account)
      delete post_url, headers: { Authorization: response['Authorization'] }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
