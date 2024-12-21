module Types
  class UpdateTextPostAttributes < BaseInputObject
    description 'The attributes to update a text post'
    argument :title, String, required: false
    argument :body, String, required: false
  end
end
