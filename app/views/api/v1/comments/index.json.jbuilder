json.data do
  json.array! @comments do |comment|
    # Comment Data
    json.partial! 'api/v1/comments/comment', comment: comment, current_account: @current_account
  end
end
