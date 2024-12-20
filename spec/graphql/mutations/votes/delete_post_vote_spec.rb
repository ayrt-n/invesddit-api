require 'rails_helper'

RSpec.describe 'delete post vote mutation' do
  let(:account) { create(:account) }
  let(:query) do
    <<~GRAPHQL
      mutation DeletePostVote($postId: ID!) {
        deletePostVote(input: { postId: $postId }) {
          errors {
            path
            message
          }
        }
      }
    GRAPHQL
  end

  context 'when user authenticated' do
    it 'deletes the vote on post' do
      vote = create(:vote, :for_post, vote_type: 1, account:)

      InvesdditApiSchema.execute(
        query:,
        context: { current_account: account },
        variables: { postId: vote.votable.id }
      )

      expect(Vote.exists?(vote.id)).to be(false)
    end
  end

  context 'when user not authenticated' do
    it 'does not delete the vote and returns errors' do
      vote = create(:vote, :for_post, vote_type: 1, account:)

      res = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: { postId: vote.votable.id }
      )

      expect(Vote.exists?(vote.id)).to be(true)
      expect(res.to_h['data']['deletePostVote']['errors']).not_to be_empty
    end
  end
end
