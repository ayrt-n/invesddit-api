module Votable
  extend ActiveSupport::Concern

  included do
    # Ordering scopes associated with votables
    scope :sort_by_best, -> { order(cached_confidence_score: :desc, id: :desc) }
    scope :sort_by_hot, -> { order(cached_hot_rank: :desc, id: :desc) }
    scope :sort_by_top, -> { order(cached_score: :desc, id: :desc) }

    # Update cached rankings when upvote / downvote count changes
    before_save :update_cached_rankings, if: :ranking_update_required?

    def update_cached_rankings
      rank = Rank.new(upvotes: cached_upvotes, downvotes: cached_downvotes, created_at:)

      self.cached_score = rank.score
      self.cached_hot_rank = rank.hot_rank
      self.cached_confidence_score = rank.confidence_score
    end

    # Find and return the vote type (up / down) for a given account
    # If account has not, returns nil
    def vote_type_by_account(account)
      votes.find_by(account:)&.vote_type
    end

    # Increment upvote count
    def add_upvote
      increment(:cached_upvotes)
      save
    end

    # Increment downvote count
    def add_downvote
      increment(:cached_downvotes)
      save
    end

    # Decrement upvote count
    def remove_upvote
      decrement(:cached_upvotes)
      save
    end

    # Decrement downvote count
    def remove_downvote
      decrement(:cached_downvotes)
      save
    end

    def switch_downvote_to_upvote
      increment(:cached_upvotes)
      decrement(:cached_downvotes)
      save
    end

    def switch_upvote_to_downvote
      decrement(:cached_upvotes)
      increment(:cached_downvotes)
      save
    end

    private

    # If upvotes/downvotes changed, will need to update cached ranking
    def ranking_update_required?
      cached_upvotes_changed? || cached_downvotes_changed?
    end
  end
end
