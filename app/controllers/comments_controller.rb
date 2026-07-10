class CommentsController < ApplicationController
  before_action :set_post
  before_action :require_user

  def create
    @comment = Current.session.user.comments.new(comment_params)
    @comment.post = @post

    if @comment.save
      redirect_to post_path(@post), notice: "コメントを投稿しました"
    else
      redirect_to post_path(@post), alert: "コメントを入力してください"
    end
  end

  def destroy
    comment = @post.comments.find(params[:id])

    if comment.user == Current.session.user
      comment.destroy
      redirect_to post_path(@post), notice: "コメントを削除しました"
    else
      redirect_to post_path(@post), alert: "権限がありません"
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def require_user
    redirect_to new_session_path, alert: "ログインしてください" unless Current.session&.user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
