json.id post.id
json.title post.title
json.body post.body
json.comments_count post.comments_count
json.created_at post.created_at
json.score post.cached_score
json.vote_status current_account ? post.vote_type_by_account(current_account) : nil
