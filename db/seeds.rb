# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "seedの実行を開始"

def attach_image(post, filename)
  image_path = Rails.root.join("db/fixtures", filename)

  return unless File.exist?(image_path)
  return if post.image.attached?

  post.image.attach(
    io: File.open(image_path),
    filename: filename,
    content_type: "image/jpeg"
  )
end

test_user = User.find_or_create_by!(email_address: "test@example.com") do |user|
  user.name = "test"
  user.password = "password"
  user.password_confirmation = "password"
  user.introduction = "よろしくお願いいたします。"
end

test_user2 = User.find_or_create_by!(email_address: "test2@example.com") do |user|
  user.name = "test2"
  user.password = "password"
  user.password_confirmation = "password"
  user.introduction = "ゴルフ初心者です。楽しく練習しています。"
end

post1 = Post.find_or_create_by!(title: "初めての打ちっぱなし", user: test_user) do |post|
  post.facility_name = "サンプルゴルフ練習場"
  post.address = "北海道札幌市"
  post.play_style = :driving_range
  post.score = 120
  post.body = "今日はドライバーの練習をしました。\n少しずつ安定してきました。"
end

attach_image(post1, "sample-post1.jpeg")

post2 = Post.find_or_create_by!(title: "ハーフラウンド", user: test_user) do |post|
  post.facility_name = "サンプルゴルフ場"
  post.address = "北海道苫小牧市"
  post.play_style = :half_round
  post.score = 45
  post.body = "パターが少し良くなりました。\n次はアプローチを改善したいです。"
end

attach_image(post2, "sample-post2.jpeg")

post3 = Post.find_or_create_by!(title: "1ラウンド", user: test_user2) do |post|
  post.facility_name = "サンプルカントリークラブ"
  post.address = "北海道千歳市"
  post.play_style = :full_round
  post.score = 92
  post.body = "後半で少し崩れましたが、楽しく回れました。\n次回は90切りを目指します。"
end

attach_image(post3, "sample-post3.jpeg")

puts "seedの実行が完了しました"
