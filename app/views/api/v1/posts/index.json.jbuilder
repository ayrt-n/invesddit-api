json.data do
  json.array! @posts do |post|
    # Post Data
    json.partial! 'api/v1/posts/post', post: post

    # Posts Communtiy Data
    json.community do
      json.partial! 'api/v1/communities/community', community: post.community
    end

    # Posts Author (Account) Data
    json.account do
      json.partial! 'api/v1/accounts/account', account: post.account
    end
  end
end
