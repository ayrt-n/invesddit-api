# Concrete FeedQuery Strategy
# Used for querying for community pages feed
class CommunityFeedQuery < FeedQuery
  def build(params)
    feed = filter_by_communities(@collection, params[:community_id])
    sort_by(feed, params[:sort_by])
  end
end
