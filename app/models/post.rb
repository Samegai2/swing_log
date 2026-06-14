class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  enum :play_style, {
    driving_range: 0,
    half_round: 1,
    full_round: 2
  }

  validates :title, presence: true
  validates :facility_name, presence: true
  validates :address, presence: true
  validates :play_style, presence: true
  validates :body, presence: true

end
