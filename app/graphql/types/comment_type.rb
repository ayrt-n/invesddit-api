module Types
  class CommentType < Types::BaseObject
    # Scalar fields
    field :id, ID, null: false
    field :body, String, null: true
    field :account_id, Integer, null: false
    field :post_id, Integer, null: false
    field :reply_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :cached_score, Integer, null: false
    field :cached_hot_rank, Float, null: true
    field :cached_upvotes, Integer, null: true
    field :cached_downvotes, Integer, null: true
    field :cached_confidence_score, Float, null: true

    # Enum fields
    field :status, Types::StatusEnumType, null: true

    # Association fields
    field :account, Types::AccountType, null: false
    field :replies, [Types::CommentType], null: false
  end
end
