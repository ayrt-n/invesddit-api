module Types
  class AccountType < Types::BaseObject
    field :id, ID, null: false
    field :status, Integer, null: false
    field :email, String, null: false
    field :password_hash, String, null: false
    field :username, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :unread_notification_count, Integer, null: false
    field :posts, [Types::PostType], null: false do
      argument :sort_by, Types::PostSortEnumType, required: false, default_value: 'hot'
    end

    def posts(sort_by:)
      ProfileFeedQuery.new.build({ account_id: object.username, sort_by: })
    end
  end
end
