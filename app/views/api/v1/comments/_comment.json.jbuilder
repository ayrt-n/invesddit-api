# Comment Data
json.id comment.id
json.post_id comment.post_id
json.body comment.body
json.score comment.cached_score
json.created_at comment.created_at
json.vote_status current_account_votes.find { |v| v.votable_id == comment.id }&.vote_type

# Comment Author (Account) Data
json.account do
  json.partial! 'api/v1/accounts/account', account: comment.account
end

# Nested Comments Data
# If no nested comments, renders empty array
json.comments do
  if replies
    json.array! replies[comment.id], partial: 'api/v1/comments/comment', as: :comment, replies:, current_account_votes:
  else
    json.array!
  end
end
