class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community

  has_many :comments, as: :commentable

  has_many :votes, as: :votable
  include Votable

  validates :title, presence: true

  scope :filter_by_community, ->(community) { joins(:community).where('communities.sub_dir = ?', community) }
end
