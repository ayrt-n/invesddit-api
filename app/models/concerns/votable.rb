module Votable
  extend ActiveSupport::Concern

  included do
    # Check if account has voted for votable and return bool
    def account_voted?(account)
      votes.pluck(:account_id).include?(account.id)
    end
  end
end
