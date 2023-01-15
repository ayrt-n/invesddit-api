require 'rails_helper'

RSpec.describe '/POST create-account', type: :request do
  let(:account) { build(:account) }
  let(:create_account_url) { '/create-account' }

  it 'creates an account' do
    account_params = {
      login: account.email,
      password: account.password,
      'password-confirm': account.password
    }
    post create_account_url, params: account_params, as: :json

    expect(response.status).to eq(200)
    expect(Account.last.email).to eq(account.email)
  end
end
