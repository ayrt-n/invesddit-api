module Mutations
  class CreateLinkPost < Mutations::BaseMutation
    argument :community_id, String, required: true
    argument :attributes, Types::CreateLinkPostAttributes, required: true

    field :post, Types::PostType, null: true
    field :errors, [Types::UserError], null: false

    def resolve(community_id:, attributes:)
      community = Community.friendly.find(community_id)
      post = Post.new(
        community_id: community.id,
        account_id: context[:current_account]&.id,
        type: 'LinkPost',
        **attributes.to_h
      )

      if post.save
        { post:, errors: [] }
      else
        user_errors = post.errors.map do |error|
          path = ['attributes', error.attribute.to_s.camelize(:lower)]
          { path:, message: error.full_message }
        end

        { post: nil, errors: user_errors }
      end
    end
  end
end
