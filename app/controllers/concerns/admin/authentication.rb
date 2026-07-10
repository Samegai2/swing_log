
module Admin::Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated_admin?
    helper_method :current_admin
  end
  
  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def current_admin
    resume_session
    Current.admin
  end

  def authenticated_admin?
    current_admin.present?
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    session = Session.find_by(id: cookies.signed[:admin_session_id])
    return nil if session.nil?
    return nil if session.admin.nil?

    session
  end

  def request_authentication
    session[:admin_return_to_after_authenticating] = request.url
    redirect_to admin_sign_in_path
  end

  def after_authentication_url
    session.delete(:admin_return_to_after_authenticating) || root_path
  end

  def after_logout_url
    admin_sign_in_path
  end
  
  def start_new_session_for(admin)
    admin_session = admin.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    )

    Current.session = admin_session

    cookies.signed.permanent[:admin_session_id] = {
      value: admin_session.id,
      httponly: true,
      same_site: :lax
    }
  end

  def terminate_session 
    Current.session&.destroy 
    cookies.delete(:admin_session_id) 
    Current.session = nil 
  end
end