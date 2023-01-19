class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community

  has_many :comments, as: :commentable

  validates :title, presence: true
end
