json.id post.id
json.type post.type
json.title post.title
json.body post.body
json.comments_count post.comments_count
json.created_at post.created_at
json.score post.cached_score
json.image post.type == 'MediaPost' ? rails_blob_url(post.image) : nil
