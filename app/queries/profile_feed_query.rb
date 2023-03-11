# Concrete FeedQuery Strategy
# Used for querying for users profile feed
class ProfileFeedQuery < FeedQuery
  def build(params)
    account = Account.friendly.find(params[:account_id])
    feed = filter_by_account(@collection, account)
    sort_by(feed, params[:sort_by])
  end
end
