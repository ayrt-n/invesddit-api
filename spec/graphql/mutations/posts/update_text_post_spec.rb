require 'rails_helper'

RSpec.describe 'updateTextPost mutation', type: :request do
  let(:account) { create(:account, :verified) }
  let(:query) do
    <<~GRAPHQL
      mutation UpdateTextPost($postId: ID!, $attributes: UpdateTextPostAttributes!) {
        updateTextPost(input: { postId: $postId, attributes: $attributes }) {
          post {
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

  it 'updates the text post' do
    post = create(:post, account:)
    InvesdditApiSchema.execute(
      query:,
      context: { current_account: account },
      variables: {
        postId: post.id,
        attributes: { title: 'NEW TITLE', body: 'NEW BODY' }
      }
    )

    post.reload
    expect(post.title).to eq('NEW TITLE')
    expect(post.body).to eq('NEW BODY')
  end

  context 'when request not made by author' do
    it 'does not update the post and returns errors' do
      post = create(:post)
      result = InvesdditApiSchema.execute(
        query:,
        context: { current_account: account },
        variables: {
          postId: post.id,
          attributes: { title: 'NEW TITLE', body: 'NEW BODY' }
        }
      )

      post.reload
      expect(post.title).not_to eq('NEW TITLE')
      expect(post.body).not_to eq('NEW BODY')
      expect(result.to_h['data']['updateTextPost']['errors']).not_to be_empty
    end
  end
end
