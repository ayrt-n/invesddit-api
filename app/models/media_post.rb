class MediaPost < Post
  # Media post must include image
  validates :image, presence: true

  # Prevent user from updating media
  before_update :prevent_update

  # If media post deleted, return nil for content
  # Otherwise return link to display media
  def content
    deleted? ? nil : image.url
  end

  private

  def prevent_update
    errors.add(:base, 'cannot update media post content')
  end
end
