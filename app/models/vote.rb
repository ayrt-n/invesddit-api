class Vote < ApplicationRecord
  belongs_to :account
  belongs_to :votable, polymorphic: true

  enum :vote_type, { downvote: -1, upvote: 1 }

  validates :account_id, uniqueness: { scope: %i[votable_id votable_type], message: 'has already voted on this item' }

  after_create :update_votable_on_create
  after_update :update_votable_on_update
  after_destroy :update_votable_on_destroy

  # Query all votes by select users
  scope :for_votables_and_account, ->(votables, account) { where(votable: votables).where(account:) }

  # Increment/decrement votable score following creation, depending on up/downvote
  def update_votable_on_create
    vote_type == 'upvote' ? votable.add_upvote : votable.add_downvote
  end

  # Increment/decrement votable score following update, depending on up/downvote
  def update_votable_on_update
    # Return unless a change was made to type (e.g., upvote changed to downvote or vice versa)
    return unless saved_change_to_vote_type

    # If vote type changed to upvote, switch downvote to upvote on votable
    # Otherwise do opposite
    vote_type == 'upvote' ? votable.switch_downvote_to_upvote : votable.switch_upvote_to_downvote
  end

  # Increment/decrement votable score following destroy, depending on up/downvote
  # After destroy, must decrement if upvote is destroyed or increment if downvote was destroyed
  def update_votable_on_destroy
    vote_type == 'upvote' ? votable.remove_upvote : votable.remove_downvote
  end
end
