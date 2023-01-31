class Vote < ApplicationRecord
  belongs_to :account
  belongs_to :votable, polymorphic: true

  enum :vote_type, { downvote: -1, upvote: 1 }

  after_create :update_score_on_create
  after_update :update_score_on_update
  after_destroy :update_score_on_destroy

  # Increment/decrement votable score following creation, depending on up/downvote
  def update_score_on_create
    vote_type == 'upvote' ? votable.increment!(:cached_score) : votable.decrement!(:cached_score)
  end

  # Increment/decrement votable score following update, depending on up/downvote
  # After an update, must increment/decrement by two to reflect removal of previous vote and the new vote
  def update_score_on_update
    # Return if change was not made to type (e.g., upvote changed to downvote or vice versa)
    return unless saved_change_to_vote_type

    vote_type == 'upvote' ? votable.increment!(:cached_score, 2) : votable.decrement!(:cached_score, 2)
  end

  # Increment/decrement votable score following destroy, depending on up/downvote
  # After destroy, must decrement if upvote is destroyed or increment if downvote was destroyed
  def update_score_on_destroy
    vote_type == 'upvote' ? votable.decrement!(:cached_score) : votable.increment!(:cached_score)
  end
end
