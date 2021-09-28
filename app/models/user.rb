class User < ApplicationRecord
  has_secure_password
  has_paper_trail on: :update, only: %i[archived deleted]
  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications

  validates :email, presence: true, uniqueness: true

  after_update :send_notifiction

  scope :apply_filters, ->(filters) { where(filters) }

  def send_notifiction
    return unless saved_change_to_archived? || saved_change_to_deleted?

    notification = UserNotification.with({})
    notification.deliver_later(self)
  end
end
