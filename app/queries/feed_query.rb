# Abstract FeedQuery Strategy Interface
class FeedQuery
  def build(_collection, _current_account, _params)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # Filter collection by single community or array of communities
  def filter_by_communities(collection, communities)
    collection.filter_by_communities(communities)
  end

  # Remove any community filters
  def remove_communities_filter(collection)
    collection.all_communities
  end

  # Filter collection by Account
  def filter_by_account(collection, account)
    collection.filter_by_account(account)
  end

  # Sort scope by metric, default 'hot'
  def sort_by(collection, metric)
    case metric
    when 'new'
      collection.sort_by_new
    when 'top'
      collection.sort_by_top
    else
      collection.sort_by_hot
    end
  end
end
