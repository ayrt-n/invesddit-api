require 'rails_helper'

RSpec.describe 'querying post feed' do
  let(:query) do
    <<~GRAPHQL
      query GetPostFeed($filter: PostFilterEnum) {
        posts(filter: $filter) {
          id
          community {
            id
          }
        }
      }
    GRAPHQL
  end

  before(:each) do
    # Create account, communities, and posts
    @account = create(:account)
    @community1 = create(:community)
    @community2 = create(:community)
    @community3 = create(:community)

    2.times do
      create(:post, community: @community1)
      create(:post, community: @community2)
      create(:post, community: @community3)
    end

    # Follow communities 1 and 2
    create(:membership, account: @account, community: @community1)
    create(:membership, account: @account, community: @community2)
  end

  context 'when user authenticated' do
    it 'returns only posts for communities the user follows' do
      results = InvesdditApiSchema.execute(
        query:,
        context: { current_account: @account },
        variables: { filter: nil }
      )

      post_ids = results.to_h['data']['posts'].map { |post| post['community']['id'].to_i }

      expect(post_ids).to all(be_in([@community1.id, @community2.id]))
    end

    it 'returns all posts when filter set to all' do
      results = InvesdditApiSchema.execute(
        query:,
        context: { current_account: @account },
        variables: { filter: 'ALL' }
      )

      post_ids = results.to_h['data']['posts'].map { |post| post['community']['id'].to_i }

      expect(post_ids).to include(@community3.id)
    end
  end

  context 'when no user authenticated' do
    it 'returns all posts' do
      results = InvesdditApiSchema.execute(
        query:,
        context: {},
        variables: {}
      )

      post_ids = results.to_h['data']['posts'].map { |post| post['community']['id'].to_i }

      expect(post_ids).to include(@community1.id).and include(@community2.id).and include(@community3.id)
    end
  end
end
