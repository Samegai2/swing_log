class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      redirect_to posts_path, notice: "新規登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    reset_session
    redirect_to new_user_path, notice: "退会しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_current_user
    redirect_to root_path, alert: "権限がありません" unless @user == Current.user
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end

