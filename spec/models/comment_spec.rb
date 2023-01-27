require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to validate_presence_of(:body) }

  context 'after create' do
    it 'updates Post comment count' do
      # Create post and comments/nested comments
      post = create(:post)
      comment = create(:comment, commentable: post)
      nested_comment = create(:comment, commentable: comment)
      create(:comment, commentable: post)
      create(:comment, commentable: comment)
      create(:comment, commentable: nested_comment)

      expect(post.comments_count).to eq(5)
    end
  end
end
