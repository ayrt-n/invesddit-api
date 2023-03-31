class MediaPost < Post
  # Media post must include image
  validates :image, presence: true
  validates :image, attached: true,
                    content_type: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                    size: { less_than: 20.megabytes }

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
