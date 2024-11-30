module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :body, String, null: true
    field :account_id, Integer, null: false
    field :community_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :comments_count, Integer, null: false
    field :cached_score, Integer, null: false
    field :cached_hot_rank, Float, null: true
    field :cached_upvotes, Integer, null: true
    field :cached_downvotes, Integer, null: true
    field :cached_confidence_score, Float, null: true
    field :type, String, null: false
    field :status, Types::StatusEnumType, null: false
  end
end
