module Types
  class MutationType < Types::BaseObject
    field :create_text_post, mutation: Mutations::CreateTextPost
    field :delete_post, mutation: Mutations::DeletePost
  end
end
