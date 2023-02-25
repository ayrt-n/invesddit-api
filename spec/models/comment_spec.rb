require 'rails_helper'
require Rails.root.join('spec/concerns/votable_spec.rb')

RSpec.describe Comment, type: :model do
  it { is_expected.to validate_presence_of(:body) }
  it_behaves_like 'votable'

  context 'after create' do
    it 'increments Post comment count' do
      # Create post and comments/nested comments
      post = create(:post)
      comment = create(:comment, post:)
      nested_comment = create(:comment, post:, reply_id: comment.id)
      create(:comment, post:)
      create(:comment, post:, reply_id: comment.id)
      create(:comment, post:, reply_id: nested_comment.id)

      expect(post.comments_count).to eq(5)
    end
  end

  context 'after destroy' do
    it 'decrements Post comment count' do
      post = create(:post)
      comment = create(:comment, post:)
      create(:comment, post:)
      comment.destroy

      expect(post.comments_count).to eq(1)
    end
  end
end
