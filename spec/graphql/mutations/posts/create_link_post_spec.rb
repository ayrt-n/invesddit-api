require 'rails_helper'

RSpec.describe 'createLinkPost mutation', type: :request do
  let(:account) { create(:account, :verified) }
  let(:community) { create(:community) }
  let(:query) do
    <<~GRAPHQL
      mutation CreateLinkPost($communityId: String!, $attributes: CreateLinkPostAttributes!) {
        createLinkPost(input: { communityId: $communityId, attributes: $attributes }) {
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

  it 'creates a new link post' do
    post = build(:link_post)
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
      post = build(:link_post)
      mutation_results = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: {
          communityId: community.sub_dir,
          attributes: { title: post.title, body: post.body }
        }
      )

      expect(mutation_results.to_h['data']['createLinkPost']['errors']).not_to be_empty
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

      expect(mutation_results.to_h['data']['createLinkPost']['errors']).not_to be_empty
    end
  end
end
