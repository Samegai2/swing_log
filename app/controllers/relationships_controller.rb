class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    Current.user.follow(@user)

    redirect_back(
      fallback_location: user_path(@user),
      status: :see_other
    )
  end

  def destroy
    Current.user.unfollow(@user)

    redirect_back(
      fallback_location: user_path(@user),
      status: :see_other
    )
  end

  def followings
    @users = @user.followings.order(name: :asc)
  end

  def followers
    @users = @user.followers.order(name: :asc)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end