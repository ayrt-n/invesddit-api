module Types
  class MutationType < Types::BaseObject
    # Posts
    field :create_text_post, mutation: Mutations::CreateTextPost
    field :create_link_post, mutation: Mutations::CreateLinkPost
    field :delete_post, mutation: Mutations::DeletePost
    field :update_text_post, mutation: Mutations::UpdateTextPost

    # Votes
    field :create_post_vote, mutation: Mutations::CreatePostVote
    field :delete_post_vote, mutation: Mutations::DeletePostVote
  end
end
