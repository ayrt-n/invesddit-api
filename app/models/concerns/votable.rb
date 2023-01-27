module Votable
  extend ActiveSupport::Concern

  included do
    # Returns the score (upvotes minus downvotes)
    def score
      # Return zero if no votes on votable
      return 0 unless votes.exists?

      # If vote is upvote add one to score, if vote is downvote subtract one
      votes.reduce(0) { |score, vote| score + (vote.vote == 'upvote' ? 1 : -1) }
    end

    # Check if account has voted for votable and return bool
    def account_voted?(account)
      votes.pluck(:account_id).include?(account.id)
    end
  end
end
