module Types
  class VoteEnumType < Types::BaseEnum
    value 'UPVOTE', value: 1
    value 'DOWNVOTE', value: -1
  end
end
