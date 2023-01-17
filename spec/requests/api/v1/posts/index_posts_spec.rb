require 'rails_helper'

RSpec.describe '/GET posts', type: :request do
  it 'returns a list of all posts' do
    posts_url = '/api/v1/posts'
    3.times { create(:post) }

    get posts_url, as: :json

    expect(response.status).to eq(200)
    expect(json['posts'].length).to eq(3)
  end
end
