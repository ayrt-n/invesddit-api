require 'rails_helper'
require Rails.root.join('spec/concerns/votable_spec.rb')

shared_examples_for 'Post' do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(300) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_inclusion_of(:type).in_array(%w[TextPost LinkPost MediaPost]) }
  it_behaves_like 'votable'
end
