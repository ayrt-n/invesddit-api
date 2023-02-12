json.data do
  json.array! @posts do |post|
    # Post Data
    json.partial! 'api/v1/posts/post', post: post, current_account: @current_account

    # Posts Communtiy Data
    json.community { json.partial! 'api/v1/communities/community', community: post.community }

    # Posts Author (Account) Data
    json.account { json.partial! 'api/v1/accounts/account', account: post.account }
  end
end
