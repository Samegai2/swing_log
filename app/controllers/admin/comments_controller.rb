class Admin::CommentsController < Admin::BaseController
  before_action :set_post, only: [:index, :show, :destroy]

  def index
    @comments =
      if @post
        @post.comments.includes(:user, :post).order(created_at: :desc)
      else
        Comment.includes(:user, :post).order(created_at: :desc)
      end

    if params[:q].present?
      keyword = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"

      @comments = @comments.left_joins(:user, :post).where(
        "comments.body LIKE :keyword OR users.name LIKE :keyword OR posts.title LIKE :keyword",
        keyword: keyword
      )
    end
  end

  def show
    @comment =
      if @post
        @post.comments.find(params[:id])
      else
        Comment.find(params[:id])
      end
  end

  def destroy
    comment =
      if @post
        @post.comments.find(params[:id])
      else
        Comment.find(params[:id])
      end

    comment.destroy

    redirect_to(
      @post ? admin_post_comments_path(@post) : admin_comments_path,
      notice: "コメントを削除しました"
    )
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id]) if params[:post_id].present?
  end
end
