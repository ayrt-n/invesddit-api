require 'rails_helper'
require Rails.root.join('spec/concerns/votable_spec.rb')

RSpec.describe TextPost, type: :model do
  it_behaves_like 'Post'
end
