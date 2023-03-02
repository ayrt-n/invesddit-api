class PostFeedQuery
  attr_reader :posts, :current_account

  def initialize(posts: Post.all, current_account: nil)
    @posts = posts
    @current_account = current_account
  end

  # Filter, sort, and return posts feed
  def build_feed(params = {})
    feed = filter_by_community(posts, params)
    feed = filter_by_account(feed, params[:account_id])
    feed = sort_by(feed, params[:sort_by])
  end

  # Filter posts by communities:
  # If community specified, only return posts for the community
  # Else if filter == all or not logged in, return posts for all communities
  # Else return posts for the current accounts followed communities
  def filter_by_community(scope, params)
    if params[:community_id]
      scope.filter_by_communities(params[:community_id])
    elsif params[:filter] == 'all' || !current_account
      scope.all_communities
    else
      communities = current_account&.communities_friendly_ids
      scope.filter_by_communities(communities)
    end
  end

  # Sort scope by metric, default 'hot'
  def sort_by(scope, metric)
    case metric
    when 'new'
      scope.sort_by_new
    when 'top'
      scope.sort_by_top
    else
      scope.sort_by_hot
    end
  end

  # Filter posts by account if specified
  def filter_by_account(scope, account)
    account ? scope.filter_by_account(account) : scope
  end
end
