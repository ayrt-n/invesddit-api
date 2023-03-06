class PostFeed
  attr_reader :collection, :current_account
  attr_accessor :strategy

  # Initialize with collection (default all Posts) and a strategy (default HomeFeedQuery)
  def initialize(collection: Post.all, current_account: nil, strategy: HomeFeedQuery)
    @collection = collection
    @current_account = current_account
    @strategy = strategy
  end

  # Execute build by calling build method on the strategy, passing along collection and params
  def build(params = {})
    strategy.build(collection, current_account, params)
  end
end
