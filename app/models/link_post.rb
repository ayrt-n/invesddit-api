class LinkPost < Post
  # Link posts must include body (url)
  validates :body, presence: true

  # Prevent user from updating link
  before_update :prevent_update

  private

  def prevent_update
    errors.add(:base, 'cannot update link post content')
  end
end
