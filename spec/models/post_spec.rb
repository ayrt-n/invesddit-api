require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to validate_presence_of(:title) }

  context '#score' do
    it 'has a default score of zero' do
      post = create(:post)

      expect(post.score).to eq(0)
    end

    it 'calculates the difference between upvotes and downvotes' do
      post = create(:post)
      create(:vote, votable: post, vote: 'upvote')
      create(:vote, votable: post, vote: 'downvote')
      create(:vote, votable: post, vote: 'upvote')
      create(:vote, votable: post, vote: 'upvote')

      expect(post.score).to eq(2)
    end
  end
end
