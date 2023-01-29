require 'rails_helper'
require Rails.root.join('spec/concerns/votable_spec.rb')

RSpec.describe Post, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it_behaves_like 'votable'
end
