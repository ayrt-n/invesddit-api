require 'rails_helper'

RSpec.describe '/POST votable/:votable_id/votes', type: :request do
  it 'creates a vote associated with votable' do
    account = create(:account, :verified)
    post = create(:post)
    vote_url = "/api/v1/posts/#{post.id}/votes?upvote"

    login_with_api(account)
    post vote_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    vote = Vote.last

    expect(response.status).to eq(204)
    expect(vote.account).to eq(account)
    expect(vote.votable.id).to eq(post.id)
    expect(vote.vote_type).to eq('upvote')
  end

  it 'updates vote if account has already voted' do
    account = create(:account, :verified)
    vote = create(:vote, :for_post, account: account)
    vote_url = "/api/v1/posts/#{vote.votable.id}/votes?downvote"

    login_with_api(account)
    post vote_url, headers: {
      Authorization: response['Authorization']
    }, as: :json

    vote = Vote.last

    expect(response.status).to eq(204)
    expect(vote.vote_type).to eq('downvote')
  end
end
