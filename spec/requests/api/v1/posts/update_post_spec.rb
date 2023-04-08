require 'rails_helper'

RSpec.describe '/PATCH posts/:id', type: :request do
  it 'updates the post contents' do
    account = create(:account, :verified)
    post = create(:post, account: account)
    post_url = "/api/v1/posts/#{post.id}"

    login_with_api(account)
    patch post_url, headers: {
      Authorization: response['Authorization']
    }, params: { post: { body: 'UPDATED POST' } }, as: :json

    expect(response.status).to eq(204)
    expect(Post.find(post.id).body).to eq('UPDATED POST')
  end

  context 'when authorization header missing' do
    it 'returns status 401 and errors' do
      post = create(:post)
      post_url = "/api/v1/posts/#{post.id}"

      patch post_url, params: { post: { title: 'UPDATED POST' } }, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when request not made by post author' do
    it 'returns status 401 with errors' do
      account = create(:account, :verified)
      post = create(:post)
      post_url = "/api/v1/posts/#{post.id}"

      login_with_api(account)
      patch post_url, headers: {
        Authorization: response['Authorization']
      }, params: { post: { title: 'UPDATED POST' } }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
