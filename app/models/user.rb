class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorite_posts,
          through: :favorites,
          source: :post

  has_many :active_relationships,
          class_name: "Relationship",
          foreign_key: :follower_id,
          dependent: :destroy,
          inverse_of: :follower

  has_many :followings,
          through: :active_relationships,
          source: :followed

  has_many :passive_relationships,
          class_name: "Relationship",
          foreign_key: :followed_id,
          dependent: :destroy,
          inverse_of: :followed

  has_many :followers,
          through: :passive_relationships,
          source: :follower

  normalizes :email_address, with: ->(email_address) { email_address.strip.downcase }

  validates :email_address, presence:true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :introduction, length: { maximum: 200 }, allow_blank: true
  validates :name, presence:true

  def follow(user)
  return if self == user

  active_relationships.find_or_create_by(followed: user)
  end

  def unfollow(user)
    active_relationships.find_by(followed: user)&.destroy
  end

  def following?(user)
    followings.exists?(user.id)
  end
  

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
