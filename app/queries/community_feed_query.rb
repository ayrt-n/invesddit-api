# Concrete FeedQuery Strategy
# Used for querying for community pages feed
class CommunityFeedQuery < FeedQuery
  def build(collection, _current_account, params)
    collection = filter_by_communities(collection, params[:community_id])
    sort_by(collection, params[:sort_by])
  end
end
