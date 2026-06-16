class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :posts, dependent: :destroy

  validates :email_address, presence:true

  validates :name, presence:true
end
