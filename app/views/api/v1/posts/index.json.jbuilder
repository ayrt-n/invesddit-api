json.data do
  json.array! @posts do |post|
    # Post Data
    json.partial! 'api/v1/posts/post', post: post

    # Posts Communtiy Data
    json.community { json.partial! 'api/v1/communities/community', community: post.community }

    # Posts Author (Account) Data
    json.account { json.partial! 'api/v1/accounts/account', account: post.account }

    # Upvote/Downvote Status
    json.vote_status @current_account ? post.vote_type_by_account(@current_account) : nil
  end
end
