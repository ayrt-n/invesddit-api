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

  context '#account_voted?' do
    it 'returns false if the account has not voted' do
      vote = create(:vote, :for_post)
      post = vote.votable
      other_account = create(:account)

      expect(post.account_voted?(other_account)).to eq(false)
    end

    it 'returns true if the account has voted' do
      account = create(:account)
      vote = create(:vote, :for_post, account: account)
      post = vote.votable

      expect(post.account_voted?(account)).to eq(true)
    end
  end
end
