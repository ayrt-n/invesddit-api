# Concrete FeedQuery Strategy
# Used for querying for clients main (home) feed
class HomeFeedQuery < FeedQuery
  def build(collection, current_account, params)
    if params[:filter] == 'all' || !current_account
      collection = remove_communities_filter(collection)
    else
      communities = current_account&.communities_friendly_ids
      collection = filter_by_communities(collection, communities)
    end

    sort_by(collection, params[:sort_by])
  end
end
