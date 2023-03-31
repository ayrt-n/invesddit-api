require 'rails_helper'

RSpec.describe MediaPost, type: :model do
  it_behaves_like 'Post'
  it { is_expected.to validate_presence_of(:image) }
  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpeg', 'image/gif', 'image/webp') }
  it { is_expected.to validate_size_of(:image).less_than(20.megabytes) }
end
