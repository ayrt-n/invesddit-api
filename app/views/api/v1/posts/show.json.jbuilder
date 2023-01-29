json.data do
  # Post Data
  json.partial! 'api/v1/posts/post', post: @post

  # Posts Author (Account) Data
  json.account do
    json.partial! 'api/v1/accounts/account', account: @post.account
  end

  # Post Comments Data
  # If no comments, renders empty array
  json.comments do
    if @post.comments.exists?
      json.array! @post.comments, partial: 'api/v1/comments/comment', as: :comment
    else
      json.array!
    end
  end
end
