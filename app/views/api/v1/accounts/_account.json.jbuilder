json.id account.id
json.username account.username
json.avatar account.avatar.attached? ? account.avatar.url : nil
json.created_at account.created_at
