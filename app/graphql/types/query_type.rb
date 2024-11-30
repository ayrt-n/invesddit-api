module Types
  class QueryType < Types::BaseObject
    field :post, Types::PostType, null: false do
      argument :id, ID, required: true
    end

    field :community, Types::CommunityType, null: false do
      argument :sub_dir, String, required: true
    end

    field :account, Types::AccountType, null: false do
      argument :username, String, required: true
    end

    def community(sub_dir:)
      Community.friendly.find(sub_dir)
    end

    def account(username:)
      Account.friendly.find(username)
    end

    def post(id:)
      Post.find(id)
    end
  end
end
