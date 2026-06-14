class PostsController < ApplicationController
  allow_unauthenticated_access only: [:index ,:show]

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: "投稿しました"
    else
      render :new, status: :unprocessable_entiny
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entiny
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_owner
    redirect_to posts_path, alert: "権限がありません" unless @post.user == Current.user
  end

  def post_params
    params.require(:post).permit(:title, :facility_name, :address, :play_style, :score, :body, :image)
  end

end
