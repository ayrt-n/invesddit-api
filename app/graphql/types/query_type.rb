module Types
  class QueryType < Types::BaseObject
    field :all_posts, [PostType], null: false
    field :community, Types::CommunityType, null: false do
      argument :sub_dir, String, required: true
    end

    def all_posts
      Post.all
    end

    def community(sub_dir:)
      Community.friendly.find(sub_dir)
    end
  end
end
