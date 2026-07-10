class Admin::HomesController < Admin::BaseController
  def top
    @users_count = User.count
    @posts_count = Post.count
    @comments_count = Comment.count
  end
end