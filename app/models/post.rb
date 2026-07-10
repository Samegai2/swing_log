class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

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

  def self.search_for(content, method) 
    return all if content.blank? 

    escaped_content = ActiveRecord::Base.sanitize_sql_like(content) 

    case method 
    when "perfect" 
      where( 
        "title = :content OR facility_name = :content OR address = :content OR body = :content", 
        content: content 
      ) 
    when "forward" 
      where( 
        "title LIKE :keyword OR facility_name LIKE :keyword OR address LIKE :keyword OR body LIKE :keyword", 
        keyword: "#{escaped_content}%" 
      ) 
    when "backward" 
      where( 
        "title LIKE :keyword OR facility_name LIKE :keyword OR address LIKE :keyword OR body LIKE :keyword", 
        keyword: "%#{escaped_content}" 
      ) 
    else 
      where( 
          "title LIKE :keyword OR facility_name LIKE :keyword OR address LIKE :keyword OR body LIKE :keyword", 
          keyword: "%#{escaped_content}%" 
      ) 
    end 
  end
end
