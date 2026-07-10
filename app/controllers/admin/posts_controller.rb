class Admin::PostsController < Admin::BaseController
  def index
    @posts = Post.includes(:user).order(created_at: :desc)

    if params[:q].present?
      keyword = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"

      @posts = @posts.left_joins(:user).where(
        "posts.title LIKE :keyword OR posts.facility_name LIKE :keyword OR posts.address LIKE :keyword OR posts.body LIKE :keyword OR users.name LIKE :keyword",
        keyword: keyword
      )
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy

    redirect_to admin_posts_path, notice: "投稿を削除しました"
  end
end
