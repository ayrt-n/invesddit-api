module Votable
  extend ActiveSupport::Concern

  included do
    # Check if account has voted for votable and return bool
    def account_voted?(account)
      votes.pluck(:account_id).include?(account.id)
    end

    def vote_type_by_account(account)
      votes.find_by(account:)&.vote_type
    end
  end
end
