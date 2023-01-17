class Post < ApplicationRecord
  belongs_to :account
  belongs_to :community
end
