require 'rails_helper'

RSpec.describe 'post field query' do
  let(:query) do
    <<~GRAPHQL
      query GetPostById($postId: ID!) {
        post(id: $postId) {
            id
            title
            content
            author {
              username
            }
        }
      }
    GRAPHQL
  end

  it 'loads post by ID' do
    post = create(:post)
    result = InvesdditApiSchema.execute(
      query:,
      variables: { postId: post.id }
    )

    expect(result['data']['post']['id'].to_i).to eq(post.id)
    expect(result['data']['post']['title']).to eq(post.title)
    expect(result['data']['post']['content']).to eq(post.content)
  end

  context 'when post has been deleted' do
    it 'returns post with user and content redacted' do
      post = create(:deleted_post)
      result = InvesdditApiSchema.execute(
        query:,
        variables: { postId: post.id }
      )

      expect(result['data']['post']['content']).not_to eq(post.body)
      expect(result['data']['post']['author']).to be_nil
    end
  end
end
