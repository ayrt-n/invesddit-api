class Vote < ApplicationRecord
  belongs_to :account
  belongs_to :votable, polymorphic: true

  enum :vote, { downvote: -1, upvote: 1 }
end
