require 'rails_helper'

RSpec.describe 'community posts query' do
  let(:query) do
    <<~GRAPHQL
      query GetAccountFeed($username: String!) {
        account(username: $username) {
          posts {
            author {
              id
            }
          }
        }
      }
    GRAPHQL
  end

  it 'returns only posts from the account' do
    account = create(:account)
    3.times do
      create(:post, account:)
      create(:post)
    end

    results = InvesdditApiSchema.execute(
      query:,
      context: {},
      variables: { username: account.username }
    )

    post_ids = results.to_h['data']['account']['posts'].map { |post| post['author']['id'].to_i }

    expect(post_ids).to all(eq account.id)
  end
end
