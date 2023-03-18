require 'rails_helper'

RSpec.describe '/DESTROY comments/:id', type: :request do
  it 'deletes the comment' do
    account = create(:account, :verified)
    comment = create(:comment, account: account)
    comment_url = "/api/v1/comments/#{comment.id}"

    login_with_api(account)
    delete comment_url, headers: { Authorization: response['Authorization'] }, as: :json
    result = Comment.find(comment.id)

    expect(response.status).to eq(204)
    expect(result.status).to eq('deleted')
  end

  context 'when authorization header is missing' do
    it 'returns status 401' do
      comment = create(:comment)
      comment_url = "/api/v1/comments/#{comment.id}"

      delete comment_url, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when request not made by comment author' do
    it 'returns status 401' do
      account = create(:account, :verified)
      comment = create(:comment)
      comment_url = "/api/v1/comments/#{comment.id}"

      login_with_api(account)
      delete comment_url, headers: { Authorization: response['Authorization'] }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
