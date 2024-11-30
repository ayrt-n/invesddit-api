module Types
  class StatusEnumType < Types::BaseEnum
    value 'PUBLISHED', value: 'published'
    value 'DELETED', value: 'deleted'
  end
end
