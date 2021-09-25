class User < ApplicationRecord
  has_secure_password
  has_paper_trail on: :update, only: %i[archived deleted]

  validates :email, presence: true, uniqueness: true

  scope :apply_filters, ->(params) { where(params) }
end
