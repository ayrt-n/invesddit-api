require 'rails_helper'

RSpec.describe 'community posts query' do
  let(:query) do
    <<~GRAPHQL
      query GetCommunityFeed($subDir: String!) {
        community(subDir: $subDir) {
          posts {
            community {
              id
            }
          }
        }
      }
    GRAPHQL
  end

  it 'returns only posts from the community' do
    community = create(:community)
    other_community = create(:community)
    3.times do
      create(:post, community:)
      create(:post, community: other_community)
    end

    results = InvesdditApiSchema.execute(
      query:,
      context: {},
      variables: { subDir: community.sub_dir }
    )

    post_ids = results.to_h['data']['community']['posts'].map { |post| post['community']['id'].to_i }

    expect(post_ids).to all(eq community.id)
  end
end
