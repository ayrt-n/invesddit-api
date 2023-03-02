class PostFeedQuery
  attr_reader :posts, :current_account

  def initialize(posts = Post.all, current_account = nil)
    @posts = posts.include_feed_associations
    @current_account = current_account
  end

  def call(params = {})
    scope = by_community(posts, params)
    scope = by_account(scope, params[:account])
    scope = sort_by(scope, params[:sort_by])
  end

  # Filter posts by communities:
  # If community specified, only return posts for the community
  # Else if filter == all or not logged in, return posts for all communities
  # Else return posts for the current accounts followed communities
  def by_community(scope, params)
    if params[:community]
      scope.filter_by_communities(params[:community])
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
  def by_account(scope, account)
    return scope unless account

    scope.filter_by_account(account)
  end
end
