module Mutations
  class DeletePostVote < Mutations::BaseMutation
    argument :post_id, ID, required: true
    field :errors, [Types::UserError], null: false

    def resolve(post_id:)
      post = Post.find(post_id)
      vote = context[:current_account].votes.where(votable: post)
      vote.destroy_all

      { errors: [] }
    end

    def authorized?(**kwargs)
      super && (return true if context[:current_account])

      [false, { vote: nil, errors: [{ path: %w[attributes account], message: 'Must be logged in' }] }]
    end
  end
end
