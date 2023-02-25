json.data do
  # Comment Data
  json.id @comment.id
  json.post_id @comment.post_id
  json.body @comment.body
  json.score @comment.cached_score
  json.created_at @comment.created_at
  json.vote_status nil
  json.comments []

  # Comment Author (Account) Data
  json.account do
    json.partial! 'api/v1/accounts/account', account: @comment.account
  end
end
