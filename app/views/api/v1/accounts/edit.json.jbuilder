json.data do
  json.id @current_account.id
  json.username @current_account.username
  json.email @current_account.email
  json.avatar @current_account.avatar.attached? ? rails_blob_url(@current_account.avatar) : nil
  json.banner @current_account.banner.attached? ? rails_blob_url(@current_account.banner) : nil
  json.notifications @current_account.unread_notification_count
end
