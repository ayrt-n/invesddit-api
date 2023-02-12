json.data do
  json.id @post.id
  json.title @post.title
  json.body @post.body
  json.community @post.community.sub_dir
end
