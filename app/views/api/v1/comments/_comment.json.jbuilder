# Comment Data
json.id comment.id
json.post_id comment.post_id
json.body comment.deleted? ? '[removed]' : comment.body
json.score comment.cached_score
json.created_at comment.created_at
json.status comment.status

# Use cached @current_account_votes if provided,
# Otherwise, check and render vote type for @current_account
if @current_account_votes
  json.vote_status @current_account_votes.find { |v| v.votable_id == comment.id }&.vote_type
else
  json.vote_status comment.vote_type_by_account(@current_account)
end

# Comment Author (Account) Data (if deleted return nil)
json.account do
  if comment.deleted?
    nil
  else
    json.partial! 'api/v1/accounts/account', account: comment.account
  end
end

# Nested Comments Data
# If no nested comments, renders empty array
json.comments do
  if @comments
    json.array! @comments[comment.id], partial: 'api/v1/comments/comment', as: :comment
  else
    json.array!
  end
end
