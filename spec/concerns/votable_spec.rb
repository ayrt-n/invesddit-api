require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }

  it 'should have the cached score attributes' do
    expect(subject.attributes).to include('cached_score')
    expect(subject.attributes).to include('cached_upvotes')
    expect(subject.attributes).to include('cached_downvotes')
    expect(subject.attributes).to include('cached_hot_rank')
    expect(subject.attributes).to include('cached_confidence_score')
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

  context '#add_upvote' do
    it 'increments and saves cached_upvotes' do
      votable = create(model.to_s.underscore.to_sym)
      votable.add_upvote

      expect(votable.cached_upvotes).to eq(1)
    end
  end

  context '#add_upvote' do
    it 'increments and saves cached_upvotes' do
      votable = create(model.to_s.underscore.to_sym)
      votable.add_downvote

      expect(votable.cached_downvotes).to eq(1)
    end
  end

  context '#remove_upvote' do
    it 'decrements and saves cached_upvotes' do
      votable = create(model.to_s.underscore.to_sym, cached_upvotes: 10)
      votable.remove_upvote

      expect(votable.cached_upvotes).to eq(9)
    end
  end

  context '#add_downvote' do
    it 'increments and saves cached_downvotes' do
      votable = create(model.to_s.underscore.to_sym)
      votable.add_downvote

      expect(votable.cached_downvotes).to eq(1)
    end
  end

  context '#remove_downvote' do
    it 'decrements and saves cached_downvotes' do
      votable = create(model.to_s.underscore.to_sym, cached_downvotes: 10)
      votable.remove_downvote

      expect(votable.cached_downvotes).to eq(9)
    end
  end

  context '#switch_downvote_to_upvote' do
    it 'decrements downvote and increments upvote' do
      votable = create(model.to_s.underscore.to_sym, cached_upvotes: 5, cached_downvotes: 10)
      votable.switch_downvote_to_upvote

      expect(votable.cached_upvotes).to eq(6)
      expect(votable.cached_downvotes).to eq(9)
    end
  end

  context '#switch_upvote_to_downvote' do
    it 'decrements upvote and increments downvote' do
      votable = create(model.to_s.underscore.to_sym, cached_upvotes: 5, cached_downvotes: 10)
      votable.switch_upvote_to_downvote

      expect(votable.cached_upvotes).to eq(4)
      expect(votable.cached_downvotes).to eq(11)
    end
  end
end
