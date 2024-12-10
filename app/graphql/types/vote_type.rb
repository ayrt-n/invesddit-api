module Types
  class VoteType < Types::BaseObject
    field :id, ID, null: false
    field :vote_type, Integer, null: false
    field :account_id, Integer, null: false
    field :votable_type, String, null: true
    field :votable_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
