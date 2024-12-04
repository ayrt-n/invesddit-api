module Mutations
  class DeletePost < Mutations::BaseMutation
    argument :post_id, ID, required: true

    field :post, Types::PostType, null: true
    field :errors, [Types::UserError], null: false

    def resolve(post_id:)
      post = Post.find(post_id)
      post.deleted!

      { post:, errors: [] }
    end

    def authorized?(post_id:)
      post = Post.find(post_id)
      super && (return true if context[:current_account]&.author_of?(post))

      # If user is not authorized return [false, {DeletePostPayload with errros}]
      [false, { post:, errors: [{ path: %w[attributes account], message: 'Account must be author of post' }] }]
    end
  end
end
