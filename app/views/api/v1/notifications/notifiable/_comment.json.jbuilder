json.id notifiable.id
json.post_id notifiable.post_id
json.body notifiable.body
json.username notifiable.account.username
json.avatar notifiable.account.avatar.attached? ? notifiable.account.avatar.url : nil
json.community notifiable.post.community.sub_dir
