json.id post.id
json.type post.type
json.title post.title
json.comments_count post.comments_count
json.created_at post.created_at
json.score post.cached_score
json.status post.status

# Do not return content of post if deleted
if post.deleted?
  json.body nil
  json.image nil
else
  json.body post.deleted? ? nil : post.body
  json.image post.type == 'MediaPost' ? rails_blob_url(post.image) : nil
end
