# Concrete FeedQuery Strategy
# Used for querying for clients main (home) feed
class HomeFeedQuery < FeedQuery
  def build(params)
    if params[:filter] == 'all' || !@current_account
      feed = remove_communities_filter(@collection)
    else
      communities = @current_account&.communities_friendly_ids
      feed = filter_by_communities(@collection, communities)
    end

    sort_by(feed, params[:sort_by])
  end
end
