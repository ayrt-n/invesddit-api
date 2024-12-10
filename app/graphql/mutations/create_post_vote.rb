module Mutations
  class CreatePostVote < Mutations::BaseMutation
    argument :post_id, ID, required: true
    argument :vote_type, Types::VoteEnumType, required: true

    field :vote, Types::VoteType, null: true
    field :errors, [Types::UserError], null: false

    def resolve(post_id:, vote_type:)
      post = Post.find(post_id)
      vote = post.votes.find_or_initialize_by(account: context[:current_account])
      vote.update_attribute(:vote_type, vote_type)

      { vote:, errors: [] }
    end

    def authorized?(**kwargs)
      super && (return true if context[:current_account])

      [false, { vote: nil, errors: [{ path: %w[attributes account], message: 'Must be logged in to vote' }] }]
    end
  end
end
