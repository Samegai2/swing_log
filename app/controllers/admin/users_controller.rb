class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(created_at: :desc)

    if params[:q].present?
      keyword = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"

      @users = @users.where(
        "name LIKE :keyword OR email_address LIKE :keyword",
        keyword: keyword
      )
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    redirect_to admin_users_path, notice: "ユーザーを削除しました"
  end
end