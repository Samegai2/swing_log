class Admin::BaseController < ActionController::Base
  layout "admin"

  protect_from_forgery with: :exception

  before_action :require_admin

  helper_method :current_admin

  private

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def require_admin
    redirect_to admin_sign_in_path, alert: "管理者ログインが必要です" unless current_admin
  end
end