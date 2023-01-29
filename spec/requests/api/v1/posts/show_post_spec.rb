require 'rails_helper'

RSpec.describe '/GET posts/:id', type: :request do
  it 'returns the post' do
    post = create(:post)
    post_url = "/api/v1/posts/#{post.id}"

    get post_url, as: :json

    expect(response.status).to eq(200)
  end
end
