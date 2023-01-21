require 'rails_helper'

RSpec.describe '/DELETE votable/:votable_id/votes', type: :request do
  it 'deletes vote from votable' do
    vote = create(:vote, :for_comment)
    vote_url = "/api/v1/votes/#{vote.id}"

    login_with_api(vote.account)
    delete vote_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    record = Vote.find_by(id: vote.id)

    expect(response.status).to eq(204)
    expect(record).to be_nil
  end

  context 'when account tries to delete vote of another user' do
    it 'returns status 401 with errors' do
      other_account = create(:account)
      vote = create(:vote, :for_comment)
      vote_url = "/api/v1/votes/#{vote.id}"

      login_with_api(other_account)
      delete vote_url, headers: {
        Authorization: response['Authorization']
      }, as: :json

      expect(response.status).to eq(401)
    end
  end
end
