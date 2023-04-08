# Comment Data
json.id comment.id
json.post_id comment.post_id
json.body comment.content
json.score comment.cached_score
json.created_at comment.created_at
json.status comment.status

# Return the vote type (up / down) from votes hash if exists (otherwise return nil)
json.vote_status @votes&.values_at(comment.id)&.dig(0)&.vote_type

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
