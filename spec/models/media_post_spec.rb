require 'rails_helper'

RSpec.describe MediaPost, type: :model do
  it_behaves_like 'Post'
  it { is_expected.to validate_presence_of(:image) }
end
