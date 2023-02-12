# Comment Data
json.id comment.id
json.body comment.body
json.score comment.cached_score
json.created_at comment.created_at
json.vote_status current_account ? comment.vote_type_by_account(current_account) : nil

# Comment Author (Account) Data
json.account do
  json.partial! 'api/v1/accounts/account', account: comment.account
end

# Nested Comments Data
# If no nested comments, renders empty array
json.comments do
  if comment.comments.exists?
    json.array! comment.comments, partial: 'api/v1/comments/comment', as: :comment
  else
    json.array!
  end
end
