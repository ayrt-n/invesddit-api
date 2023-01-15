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

  context 'when account is not verified' do
    it 'returns status 403 with errors' do
      login_with_api(unverified_account)

      expect(response.status).to eq(403)
      # TO DO FORMAT AND CHECK ERRORS
    end
  end

  context 'when attributes missing' do
    it 'returns status 401 with errors' do
      account.email = ''

      login_with_api(account)

      expect(response.status).to eq(401)
      # TO DO FORMAT AND CHECK ERRORS
    end
  end
end
