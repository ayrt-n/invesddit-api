json.data do
  json.array! @accounts do |account|
    json.partial! 'api/v1/accounts/account', account:
  end
end
