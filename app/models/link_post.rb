class LinkPost < Post
  # Link posts must include body (url)
  validates :body, presence: true
end
