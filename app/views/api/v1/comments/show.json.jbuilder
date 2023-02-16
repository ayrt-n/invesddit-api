json.data do
  json.partial! 'api/v1/comments/comment', comment: @comment, current_account: @current_account
end
