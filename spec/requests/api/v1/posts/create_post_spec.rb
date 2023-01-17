require 'rails_helper'

RSpec.describe '/POST communities/:id/posts', type: :request do
  let(:account) { create(:account, :verified) }
  let(:community) { create(:community) }

  it 'creates a post' do
    post_url = "/api/v1/communities/#{community.sub_dir}/posts"
    post_params = build(:post)

    login_with_api(account)
    post post_url, headers: {
      Authorization: response['Authorization']
    }, params: post_params, as: :json

    expect(response.status).to eq(200)
    expect(Post.last.title).to eq(post_params.title)
  end
end
