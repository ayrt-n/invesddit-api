module Types
  class CreateTextPostAttributes < Types::BaseInputObject
    description 'The attributes to create a text post'
    argument :title, String, required: true
    argument :body, String, required: false
  end
end
