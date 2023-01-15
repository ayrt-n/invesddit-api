module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def login_with_api(account)
    login_params = {
      login: account.email,
      password: account.password
    }

    post '/login', params: login_params, as: :json
  end
end
