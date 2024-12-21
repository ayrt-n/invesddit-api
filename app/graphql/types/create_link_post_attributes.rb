module Types
  class CreateLinkPostAttributes < Types::BaseInputObject
    description 'The attributes to create a link post'
    argument :title, String, required: true
    argument :body, String, required: true
  end
end
