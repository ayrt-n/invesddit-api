require 'rails_helper'

RSpec.describe 'createTextPost mutation', type: :request do
  let(:account) { create(:account, :verified) }
  let(:community) { create(:community) }
  let(:query) do
    <<~GRAPHQL
      mutation CreateTextPost($communityId: String!, $attributes: CreateTextPostAttributes!) {
        createTextPost(input: { communityId: $communityId, attributes: $attributes }) {
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

  it 'creates a new text post' do
    post = build(:post)
    InvesdditApiSchema.execute(
      query:,
      context: { current_account: account },
      variables: {
        communityId: community.sub_dir,
        attributes: { title: post.title, body: post.body }
      }
    )

    latest_post = Post.last
    expect(latest_post.title).to eq(post.title)
    expect(latest_post.body).to eq(post.body)
  end

  context 'when authorization is missing' do
    it 'does not create post and returns errors' do
      mutation_results = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: {
          communityId: community.sub_dir,
          attributes: { title: 'Test', body: 'Test' }
        }
      )

      expect(mutation_results.to_h['data']['createTextPost']['errors']).not_to be_empty
    end
  end

  context 'when attributes invalid' do
    it 'does not create post and returns errors' do
      mutation_results = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: {
          communityId: community.sub_dir,
          attributes: { title: '', body: '' }
        }
      )

      expect(mutation_results.to_h['data']['createTextPost']['errors']).not_to be_empty
    end
  end
end
