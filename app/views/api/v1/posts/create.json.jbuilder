# Simply returns all the information required from the frontend following the creation of a post
# to redirect to the new post page, e.g., /c/[community.sub_dir]/posts/[post.id]
json.data do
  json.id @post.id
  json.community @post.community.sub_dir
end
