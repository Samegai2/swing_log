class Admin < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(email_address) { email_address.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
