require 'rails_helper'

RSpec.describe '/DELETE votable/:votable_id/votes', type: :request do
  it 'deletes vote from votable' do
    vote = create(:vote, :for_comment)
    vote_url = "/api/v1/comments/#{vote.votable.id}/votes"

    login_with_api(vote.account)
    delete vote_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    record = Vote.find_by(id: vote.id)

    expect(response.status).to eq(204)
    expect(record).to be_nil
  end
end
