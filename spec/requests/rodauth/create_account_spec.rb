require 'rails_helper'

RSpec.describe '/POST create-account', type: :request do
  let(:account) { build(:account) }
  let(:create_account_url) { '/create-account' }

  it 'creates an account' do
    account_params = {
      login: account.email,
      username: account.username,
      password: account.password,
      'password-confirm': account.password
    }
    post create_account_url, params: account_params, as: :json

    record = Account.last

    expect(response.status).to eq(200)
    expect(record.email).to eq(account.email)
    expect(record.username).to eq(account.username)
  end

  context 'when there are invalid attributes' do
    it 'returns status 422 with errors' do
      invalid_account_params = {
        login: account.email,
        username: '',
        password: account.password,
        'password-confirm': account.password
      }

      post create_account_url, params: invalid_account_params, as: :json

      expect(response.status).to eq(422)
    end
  end
end
