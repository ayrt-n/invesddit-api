class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3

  validates :username, presence: true
  validates :username, length: { in: 3..20 }
  validates :username, format: { without: /\W/ }
  validates :username, uniqueness: true

  has_many :memberships
  has_many :communities, through: :memberships

  def join_community(community_sub_dir)
    community = Community.friendly.find(community_sub_dir)
    memberships.create(community:)
  end
end
