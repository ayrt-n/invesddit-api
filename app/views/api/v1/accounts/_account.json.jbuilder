json.id account.id
json.username account.username
json.avatar account.avatar.attached? ? rails_blob_url(account.avatar) : nil
json.created_at account.created_at
