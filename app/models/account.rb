class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3

  validates :username, presence: true
  validates :username, length: { in: 3..20 }
  validates :username, format: { without: /\W/ }
  validates :username, uniqueness: true

  has_many :memberships
  has_many :communities, through: :memberships
  has_many :votes

  def join_community(community)
    memberships.create(community:)
  end

  def communities_friendly_ids
    communities.pluck(:sub_dir)
  end
end
