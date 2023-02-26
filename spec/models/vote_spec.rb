require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'after create' do
    it 'updates the cached_score value of votable' do
      upvote = create(:vote, vote_type: 'upvote')
      downvote = create(:vote, vote_type: 'downvote')

      expect(upvote.votable.cached_score).to eq(1)
      expect(downvote.votable.cached_score).to eq(-1)
    end
  end

  context 'after update' do
    it 'updates the cached_score value of votable if changed' do
      original_upvote = create(:vote, vote_type: 'upvote')
      original_downvote = create(:vote, vote_type: 'downvote')
      no_change_vote = create(:vote, vote_type: 'upvote')

      original_upvote.update_attribute(:vote_type, 'downvote')
      original_downvote.update_attribute(:vote_type, 'upvote')
      no_change_vote.update_attribute(:vote_type, 'upvote')

      expect(original_upvote.votable.cached_score).to eq(-1)
      expect(original_downvote.votable.cached_score).to eq(1)
      expect(no_change_vote.votable.cached_score).to eq(1)
    end
  end

  context 'after destroy' do
    it 'updates the cached_score value of votable if changed' do
      upvote = create(:vote, vote_type: 'upvote')
      upvote.destroy

      expect(upvote.votable.cached_score).to eq(0)
    end
  end

  describe '#for_votables_and_account' do
    context 'when votes exist' do
      it 'returns all votes by votables and account' do
        account = create(:account)
        votables = []
        3.times { votables << create(:vote, account:).votable }
        2.times { create(:vote, account:) }

        result = Vote.for_votables_and_account(votables, account)

        expect(result.length).to eq(3)
      end
    end
  end
end
