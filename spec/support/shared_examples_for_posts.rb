require 'rails_helper'
require Rails.root.join('spec/concerns/votable_spec.rb')

shared_examples_for 'Post' do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(300) }
  it_behaves_like 'votable'
end
