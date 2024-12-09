module Types
  class CommunityType < Types::BaseObject
    field :id, ID, null: false
    field :sub_dir, String, null: false
    field :title, String, null: true
    field :description, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :members_count, Integer, null: false
    field :posts, [Types::PostType], null: false do
      argument :sort_by, Types::PostSortEnumType, required: false, default_value: 'HOT'
    end

    def posts(sort_by:)
      CommunityFeedQuery.new.build({ community_id: object.sub_dir, sort_by: })
    end
  end
end
