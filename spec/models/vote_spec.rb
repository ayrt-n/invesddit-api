require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'after create' do
    it 'updates the cached_score value of votable' do
      upvote = create(:vote, type: 'upvote')
      downvote = create(:vote, type: 'downvote')

      expect(upvote.votable.cached_score).to eq(1)
      expect(downvote.votable.cached_score).to eq(-1)
    end
  end

  context 'after update' do
    it 'updates the cached_score value of votable if changed' do
      original_upvote = create(:vote, type: 'upvote')
      original_downvote = create(:vote, type: 'downvote')
      no_change_vote = create(:vote, type: 'upvote')

      original_upvote.update_attribute(:type, 'downvote')
      original_downvote.update_attribute(:type, 'upvote')
      no_change_vote.update_attribute(:type, 'upvote')

      expect(original_upvote.votable.cached_score).to eq(-1)
      expect(original_downvote.votable.cached_score).to eq(1)
      expect(no_change_vote.votable.cached_score).to eq(1)
    end
  end

  context 'after destroy' do
    it 'updates the cached_score value of votable if changed' do
      upvote = create(:vote, type: 'upvote')
      upvote.destroy

      expect(upvote.votable.cached_score).to eq(0)
    end
  end
end
