class MediaPost < Post
  has_one_attached :image
  validates :image, presence: true
end
