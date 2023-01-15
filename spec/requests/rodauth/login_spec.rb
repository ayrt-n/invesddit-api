require 'rails_helper'

RSpec.describe '/POST login', type: :request do
  let(:account) { create(:account, :verified) }
  let(:unverified_account) { create(:account) }
  let(:login_url) { '/login' }

  context 'when account is verified' do
    it 'returns status 200 with authorization token' do
      login_with_api(account)

      expect(response.status).to eq(200)
      expect(response.headers['Authorization']).to be_present
    end
  end
end
