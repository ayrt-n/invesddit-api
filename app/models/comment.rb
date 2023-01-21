class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :account

  has_many :comments, as: :commentable
  has_many :votes, as: :votable

  validates :body, presence: true
end
