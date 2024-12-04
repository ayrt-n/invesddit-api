require 'rails_helper'

RSpec.describe 'deletePost mutation', type: :request do
  let(:query) do
    <<~GRAPHQL
      mutation DeletePost($postId: ID!) {
        deletePost(input: { postId: $postId }) {
          post {
            id
            status
          }
          errors {
            path
            message
          }
        }
      }
    GRAPHQL
  end

  it 'softly deletes the post' do
    current_account = create(:account, :verified)
    post = create(:post, account: current_account)

    mutation_results = InvesdditApiSchema.execute(
      query:,
      context: { current_account: },
      variables: { postId: post.id }
    )

    p mutation_results

    post.reload
    expect(post.status).to eq('deleted')
    expect(mutation_results['data']['deletePost']['errors']).to be_empty
  end

  context 'when request not made by post author' do
    it 'does not delete and returns errors' do
      current_account = create(:account, :verified)
      post = create(:post)

      mutation_results = InvesdditApiSchema.execute(
        query:,
        context: { current_account: },
        variables: { postId: post.id }
      )

      post.reload
      expect(post.status).to eq('published')
      expect(mutation_results['data']['deletePost']['errors']).not_to be_empty
    end
  end

  context 'when authorization is missing' do
    it 'does not delete and returns errors' do
      post = create(:post)

      mutation_results = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: { postId: post.id }
      )

      post.reload
      expect(post.status).to eq('published')
      expect(mutation_results['data']['deletePost']['errors']).not_to be_empty
    end
  end
end
