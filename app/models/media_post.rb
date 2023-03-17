class MediaPost < Post
  # Media post must include image
  validates :image, presence: true

  # Prevent user from updating media
  before_update :prevent_update

  private

  def prevent_update
    errors.add(:base, 'cannot update media post content')
  end
end
