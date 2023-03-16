require 'rails_helper'

RSpec.describe '/GET posts/:id', type: :request do
  it 'returns the post' do
    post = create(:post)
    post_url = "/api/v1/posts/#{post.id}"

    get post_url, as: :json

    data = json['data']

    expect(response.status).to eq(200)
    expect(data['status']).to eq('published')
    expect(data['body']).to eq(post.body)
  end

  context 'when post has been deleted' do
    it 'returns post with user and content redacted' do
      post = create(:post, status: 'deleted')
      post_url = "/api/v1/posts/#{post.id}"

      get post_url, as: :json

      data = json['data']

      expect(response.status).to eq(200)
      expect(data['status']).to eq('deleted')
      expect(data['account']).to be_nil
      expect(data['body']).to be_nil
    end
  end
end
