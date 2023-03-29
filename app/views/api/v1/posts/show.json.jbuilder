json.data do
  # Post Data
  json.partial! 'api/v1/posts/post', post: @post, current_account: @current_account
  json.vote_status @vote&.vote_type

  # Posts Author (Account) Data
  json.account do
    if @post.deleted?
      nil
    else
      json.partial! 'api/v1/accounts/account', account: @post.account
    end
  end
end
