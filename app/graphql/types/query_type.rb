module Types
  class QueryType < Types::BaseObject
    field :posts, [Types::PostType], null: false do
      argument :filter, Types::PostFilterEnumType, required: false
      argument :sort_by, Types::PostSortEnumType, required: false, default_value: 'hot'
    end

    def posts(sort_by:, filter: nil)
      HomeFeedQuery.new(current_account: context[:current_account])
                   .build({ filter:, sort_by: })
    end

    field :post, Types::PostType, null: false do
      argument :id, ID, required: true
    end

    def post(id:)
      Post.find(id)
    end

    field :community, Types::CommunityType, null: false do
      argument :sub_dir, String, required: true
    end

    def community(sub_dir:)
      Community.friendly.find(sub_dir)
    end

    field :account, Types::AccountType, null: false do
      argument :username, String, required: true
    end

    def account(username:)
      Account.friendly.find(username)
    end
  end
end
