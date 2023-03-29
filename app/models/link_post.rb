class LinkPost < Post
  # Link posts must include body (url)
  validates :body, presence: true

  # Prevent user from updating link
  before_update :prevent_update

  # If link post deleted, return nil for content
  # Otherwise return the body
  def content
    deleted? ? nil : body
  end

  private

  def prevent_update
    errors.add(:base, 'cannot update link post content')
  end
end
