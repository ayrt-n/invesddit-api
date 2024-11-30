module Types
  class CommunityType < Types::BaseObject
    field :id, ID, null: false
    field :sub_dir, String, null: false
    field :title, String, null: true
    field :description, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :members_count, Integer, null: false
    field :posts, [Types::PostType], null: false
  end
end
