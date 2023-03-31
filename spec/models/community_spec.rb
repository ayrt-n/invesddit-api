require 'rails_helper'

RSpec.describe Community, type: :model do
  it { is_expected.to validate_presence_of(:sub_dir) }
  it { is_expected.to validate_uniqueness_of(:sub_dir) }
  it { is_expected.to validate_length_of(:sub_dir).is_at_most(20) }
  it { is_expected.to validate_length_of(:title).is_at_most(20) }
  it { is_expected.to validate_length_of(:description).is_at_most(500) }
  it { is_expected.to validate_content_type_of(:avatar).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_content_type_of(:banner).allowing('image/png', 'image/jpeg') }
  it { is_expected.to validate_size_of(:avatar).less_than(2.megabytes) }
  it { is_expected.to validate_size_of(:banner).less_than(5.megabytes) }
end
