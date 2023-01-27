module Votable
  extend ActiveSupport::Concern

  included do
    def score
      # Return zero if no votes on votable
      return 0 unless votes.exists?

      # If vote is upvote add one to score, if vote is downvote subtract one
      votes.reduce(0) { |score, vote| score + (vote.vote == 'upvote' ? 1 : -1) }
    end
  end
end
