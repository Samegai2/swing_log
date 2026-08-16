class Relationship < ApplicationRecord
  belongs_to :follower,
             class_name: "User",
             inverse_of: :active_relationships

  belongs_to :followed,
             class_name: "User",
             inverse_of: :passive_relationships

  validates :followed_id,
            uniqueness: { scope: :follower_id }

  validate :cannot_follow_self

  private

  def cannot_follow_self
    return unless follower_id == followed_id

    errors.add(:followed_id, "自分自身はフォローできません")
  end
end