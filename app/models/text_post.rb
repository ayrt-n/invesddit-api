class TextPost < Post
  # If text post deleted, return nil for content
  # Otherwise return the body
  def content
    deleted? ? nil : body
  end
end
