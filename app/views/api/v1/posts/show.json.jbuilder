json.data do
  # Post Data
  json.partial! 'api/v1/posts/post', post: @post, current_account: @current_account
  json.vote_status @current_account_vote&.vote_type

  # Posts Author (Account) Data
  json.account do
    json.partial! 'api/v1/accounts/account', account: @post.account
  end
end
