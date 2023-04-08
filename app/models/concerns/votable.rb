module Votable
  extend ActiveSupport::Concern

  included do
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
  end
end
