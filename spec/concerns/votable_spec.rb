require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }

  context '#score' do
    it 'has a default score of zero' do
      votable = build(model.to_s.underscore.to_sym)

      expect(votable.score).to eq(0)
    end

    it 'returns the difference between upvotes and downvotes' do
      votable = create(model.to_s.underscore.to_sym)
      3.times { create(:vote, votable:, vote: 'upvote') }
      2.times { create(:vote, votable:, vote: 'downvote') }

      expect(votable.score).to eq(1)
    end
  end

  context '#account_voted?' do
    it 'returns false if the account has not voted' do
      votable = create(model.to_s.underscore.to_sym)
      create(:vote, votable:)
      other_account = create(:account)

      expect(votable.account_voted?(other_account)).to eq(false)
    end

    it 'returns true if the account has voted' do
      account = create(:account)
      votable = create(model.to_s.underscore.to_sym)
      create(:vote, votable:, account:)

      expect(votable.account_voted?(account)).to eq(true)
    end
  end
end
