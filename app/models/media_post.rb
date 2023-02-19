class MediaPost < Post
  has_one_attached :image, dependent: :destroy
  validates :image, presence: true
end
