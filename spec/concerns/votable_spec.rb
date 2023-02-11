require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }

  it 'should have the cached_score attribute' do
    expect(subject.attributes).to include('cached_score')
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

  context '#vote_type_by_account' do
    it 'returns upvote if account has upvoted' do
      account = create(:account)
      votable = create(model.to_s.underscore.to_sym)
      create(:vote, votable:, account:)

      expect(votable.vote_type_by_account(account)).to eq('upvote')
    end

    it 'returns downvote if account has downvoted' do
      account = create(:account)
      votable = create(model.to_s.underscore.to_sym)
      create(:vote, vote_type: 'downvote', votable:, account:)

      expect(votable.vote_type_by_account(account)).to eq('downvote')
    end

    it 'returns nil if account has not voted' do
      account = create(:account)
      votable = create(model.to_s.underscore.to_sym)

      expect(votable.vote_type_by_account(account)).to eq(nil)
    end
  end
end
