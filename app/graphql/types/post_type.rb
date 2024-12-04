module Types
  class PostType < Types::BaseObject
    # Scalar fields
    field :id, ID, null: false, description: 'The id of the post'
    field :title, String, null: false, description: 'The title of the post'
    field :content, String, null: true, description: 'The post content (text, image url, link)'
    field :account_id, Integer, null: false, description: 'The account id of the author of the post'
    field :community_id, Integer, null: false, description: 'The community id of the community the post belongs to'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The datetime the post was created'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The datetime the post was last updated'
    field :comments_count, Integer, null: false, description: 'The number of comments on the post'
    field :cached_score, Integer, null: false, description: 'The score (upvotes - downvotes) of the post'
    field :cached_hot_rank, Float, null: true, description: 'The hot ranking of the post'
    field :cached_upvotes, Integer, null: true, description: 'The number of upvotes on the post'
    field :cached_downvotes, Integer, null: true, description: 'The number of downvotes on the post'
    field :cached_confidence_score, Float, null: true, description: 'The confidence score of the post'
    field :type, String, null: false, description: 'The type of post (TEXT, MEDIA, LINK)'

    # Enum fields
    field :status, Types::StatusEnumType, null: false, description: 'The status of the post (PUBLISHED or DELETED)'

    # Association fields
    field :account, Types::AccountType, null: false, description: 'The author of the post'
    field :community, Types::CommunityType, null: false, description: 'The community the post belongs to'
    field :comments, [Types::CommentType], null: false, method: :top_level_comments,
                                           description: 'Top-level comments on the post'
  end
end
