class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  normalizes :email_address, with: ->(email_address) { email_address.strip.downcase }

  validates :email_address, presence:true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :introduction, length: { maximum: 200 }, allow_blank: true
  validates :name, presence:true

  def self.search_for(content, method)
    return all if content.blank?

    escaped_content = ActiveRecord::Base.sanitize_sql_like(content)

    case method
    when "perfect"
      where(name: content)
    when "forward"
      where("name LIKE ?", "#{escaped_content}%")
    when "backward"
      where("name LIKE ?", "%#{escaped_content}")
    else
      where(
        "name LIKE :keyword OR introduction LIKE :keyword",
        keyword: "%#{escaped_content}%"
      )
    end
  end
end
