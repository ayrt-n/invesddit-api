module Types
  class AccountType < Types::BaseObject
    field :id, ID, null: false
    field :status, Integer, null: false
    field :email, String, null: false
    field :password_hash, String, null: false
    field :username, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :unread_notification_count, Integer, null: false
    field :posts, [Types::PostType], null: false
  end
end
