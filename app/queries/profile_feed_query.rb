# Concrete FeedQuery Strategy
# Used for querying for users profile feed
class ProfileFeedQuery < FeedQuery
  def build(collection, _current_account, params)
    account = Account.friendly.find(params[:account_id])
    collection = filter_by_account(collection, account)
    sort_by(collection, params[:sort_by])
  end
end
