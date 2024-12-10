require 'rails_helper'

RSpec.describe 'create post vote mutation' do
  let(:account) { create(:account) }
  let(:query) do
    <<~GRAPHQL
      mutation CreatePostVote($postId: ID!, $voteType: VoteEnum!) {
        createPostVote(input: { postId: $postId, voteType: $voteType }) {
        vote {
          id
        }
        errors {
            path
            message
          }
        }
      }
    GRAPHQL
  end

  context 'when user authenticated' do
    it 'creates vote on post' do
      post = create(:post)

      InvesdditApiSchema.execute(
        query:,
        context: { current_account: account },
        variables: { postId: post.id, voteType: 'UPVOTE' }
      )

      post = Post.find(post.id)
      expect(post.vote_type_by_account(account)).to eq('upvote')
    end

    it 'updates the vote if it already exists' do
      # Create upvote (vote_type: 1)
      vote = create(:vote, :for_post, vote_type: 1, account:)

      InvesdditApiSchema.execute(
        query:,
        context: { current_account: account },
        variables: { postId: vote.votable.id, voteType: 'DOWNVOTE' }
      )

      vote = Vote.find(vote.id)
      expect(vote.vote_type).to eq('downvote')
    end
  end

  context 'when user not authenticated' do
    it 'does not create the vote and returns errors' do
      post = create(:post)

      result = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: { postId: post.id, voteType: 'UPVOTE' }
      )

      expect(result.to_h['data']['createPostVote']['errors']).not_to be_empty
    end
  end
end
