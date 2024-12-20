module Types
  class MutationType < Types::BaseObject
    field :create_text_post, mutation: Mutations::CreateTextPost
    field :delete_post, mutation: Mutations::DeletePost
    field :create_post_vote, mutation: Mutations::CreatePostVote
    field :delete_post_vote, mutation: Mutations::DeletePostVote
  end
end
