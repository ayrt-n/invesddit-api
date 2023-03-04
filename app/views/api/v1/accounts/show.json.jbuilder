json.data do
  json.id @account.id
  json.username @account.username
  json.avatar @account.avatar.attached? ? rails_blob_url(@account.avatar) : nil
  json.banner @account.banner.attached? ? rails_blob_url(@account.banner) : nil
  json.created_at @account.created_at
end