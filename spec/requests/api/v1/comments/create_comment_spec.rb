require 'rails_helper'

RSpec.describe '/POST /:commentable/:commentable_id/comments', type: :request do
  it 'creates comment belonging to commentable' do
    post = create(:post)
    comment = build(:comment)
    account = create(:account, :verified)
    comments_url = "/api/v1/posts/#{post.id}/comments"

    login_with_api(account)
    post comments_url, headers: {
      Authorization: response['Authorization']
    }, params: comment, as: :json

    expect(response.status).to eq(200)
    expect(Comment.all.count).to eq(1)
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
end
