module Mutations
  class UpdateTextPost < BaseMutation
    argument :post_id, ID, required: true
    argument :attributes, Types::UpdateTextPostAttributes, required: true

    field :post, Types::PostType, null: true
    field :errors, [Types::UserError], null: false

    def resolve(post_id:, attributes:)
      post = Post.find(post_id)

      if post.update(**attributes.to_h)
        { post:, errors: [] }
      else
        user_errors = post.errors.map do |error|
          path = ['attributes', error.attribute.to_s.camelize(:lower)]
          { path:, message: error.full_message }
        end

        { post: nil, errors: user_errors }
      end
    end

    def authorized?(post_id:, attributes:)
      post = Post.find(post_id)
      super && (return true if context[:current_account]&.author_of?(post))

      [false, { post:, errors: [{ path: %w[attributes account], message: 'Account must be author of post' }] }]
    end
  end
end
