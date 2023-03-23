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

    it 'notifies post and comment authors' do
      post = create(:post)
      comment = create(:comment, post:)
      create(:comment, post:, comment:)

      post_reply_notification = Notification.where(account: post.account)
      comment_reply_notification = Notification.where(account: comment.account)

      expect(post_reply_notification.count).to eq(2)
      expect(comment_reply_notification.count).to eq(1)
    end

    it 'does not create notifications if post/comment deleted' do
      post = create(:post, status: 'deleted')
      comment = create(:comment, post:, status: 'deleted')
      create(:comment, post:, comment:)

      post_reply_notification = Notification.where(account: post.account)
      comment_reply_notification = Notification.where(account: comment.account)

      expect(post_reply_notification.count).to eq(0)
      expect(comment_reply_notification.count).to eq(0)
    end

    it 'does not notify the author if they are also the commentor' do
      account = create(:account)
      post = create(:post, account:)
      comment = create(:comment, post:, account:)
      create(:comment, post:, comment:, account:)

      notifications = Notification.where(account:)

      expect(notifications.count).to eq(0)
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
