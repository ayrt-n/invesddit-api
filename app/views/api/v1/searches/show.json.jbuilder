json.data do
  json.posts do
    json.array! @posts do |post|
      # Post Data
      json.partial! 'api/v1/posts/post', post: post

      # Posts Communtiy Data
      json.community { json.partial! 'api/v1/communities/community', community: post.community }

      # Posts Author (Account) Data
      json.account { json.partial! 'api/v1/accounts/account', account: post.account }
    end
  end

  json.communities do
    json.array! @communities do |community|
      # Community Data
      json.partial! 'api/v1/communities/community', community:
    end
  end

  json.accounts do
    json.array! @accounts do |account|
      # Account Data
      json.partial! 'api/v1/accounts/account', account:
    end
  end
end
