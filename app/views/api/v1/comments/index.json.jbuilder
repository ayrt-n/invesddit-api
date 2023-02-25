json.data do
  json.array! @comments[nil] do |comment|
    # Comment Data
    json.partial! 'api/v1/comments/comment', comment:, replies: @comments, current_account_votes: @current_account_votes
  end
end
