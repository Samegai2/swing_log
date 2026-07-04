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
  validates :score, presence: true
  validates :body, presence: true

  def score_label
    if driving_range?
      "打数"
    else
      "スコア"
    end
  end
end
