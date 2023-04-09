class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3

  extend FriendlyId
  friendly_id :username

  validates :username, presence: true
  validates :username, length: { in: 3..20 }
  validates :username, format: { without: /\W/ }
  validates :username, uniqueness: true

  has_many :memberships
  has_many :communities, through: :memberships
  has_many :votes
  has_many :notifications

  has_one_attached :avatar, dependent: :destroy
  has_one_attached :banner, dependent: :destroy

  validates :avatar, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 2.megabytes }

  validates :banner, content_type: ['image/png', 'image/jpeg'],
                     size: { less_than: 5.megabytes }

  # Search Scope
  scope :search, lambda { |q|
    where('username ILIKE ?', "%#{Account.sanitize_sql_like(q)}%")
      .with_attached_avatar
  }

  # Pagination related functionality
  extend Paginator
  paginates_per_page 10

  # Join community, i.e., create a membership (default membership role is member)
  def join_community(community)
    memberships.create(community:)
  end

  # Return all sub_dir for all communities account is member of
  def communities_friendly_ids
    communities.pluck(:sub_dir)
  end

  # Mark all notifications read and change unread notification count to zero
  # If success, returns true, else returns false
  def mark_all_notifications_read
    if notifications.unread.update_all(read: true)
      update(unread_notification_count: 0)
      true
    else
      false
    end
  end
end
