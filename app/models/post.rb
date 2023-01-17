class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community

  validates :title, presence: true
end
