require 'rails_helper'

RSpec.describe '/PATCH comments/:id', type: :request do
  it 'updates the comment' do
    account = create(:account, :verified)
    comment = create(:comment, account:)
    comment_url = "/api/v1/comments/#{comment.id}"

    login_with_api(account)
    patch comment_url, headers: {
      Authorization: response['Authorization']
    }, params: { comment: { body: 'UPDATED COMMENT' } }, as: :json

    expect(response.status).to eq(204)
    expect(Comment.find(comment.id).body).to eq('UPDATED COMMENT')
  end

  context 'when authorization header missing' do
    it 'returns status 401 with errors' do
      comment = create(:comment)
      comment_url = "/api/v1/comments/#{comment.id}"

      patch comment_url, params: { comment: { body: 'UPDATED COMMENT' } }, as: :json

      expect(response.status).to eq(401)
    end
  end

  context 'when different user tries to update' do
    it 'returns status 401 with errors' do
      account = create(:account, :verified)
      comment = create(:comment)
      comment_url = "/api/v1/comments/#{comment.id}"

      login_with_api(account)
      patch comment_url, headers: {
        Authorization: response['Authorization']
      }, params: { comment: { body: 'UPDATED COMMENT' } }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
