require 'rails_helper'

RSpec.describe '/POST /posts/:post_id/comments', type: :request do
  it 'creates top-level comment belonging to post' do
    post = create(:post)
    account = create(:account, :verified)
    comments_url = "/api/v1/posts/#{post.id}/comments"

    login_with_api(account)
    post comments_url, headers: {
      Authorization: response['Authorization']
    }, params: { body: 'Test comment' }, as: :json

    expect(response.status).to eq(200)
    expect(post.comments.count).to eq(1)
  end

  it 'creates reply if reply_id param included' do
    post = create(:post)
    top_level_comment = create(:comment, post:)
    account = create(:account, :verified)
    comments_url = "/api/v1/posts/#{post.id}/comments"

    login_with_api(account)
    post comments_url, headers: {
      Authorization: response['Authorization']
    }, params: { body: 'Test comment', reply_id: top_level_comment.id },
    as: :json

    expect(response.status).to eq(200)
    expect(top_level_comment.replies.count).to eq(1)
  end

  context 'when authorization header missing' do
    it 'returns status 401 and errors' do
      post = create(:post)
      comment = build(:comment)
      comments_url = "/api/v1/posts/#{post.id}/comments"

      post comments_url, params: comment, as: :json

      expect(response.status).to eq(401)
      expect(Comment.all.count).to eq(0)
    end
  end

  context 'when invalid attributes' do
    it 'returns status 422 with errors' do
      post = create(:post)
      comment = build(:comment, post:, body: nil)
      account = create(:account, :verified)
      comments_url = "/api/v1/posts/#{post.id}/comments"

      login_with_api(account)
      post comments_url, headers: {
        Authorization: response['Authorization']
      }, params: comment, as: :json

      expect(response.status).to eq(422)
    end
  end
end
