class ApplicationController < ActionController::Base
  # @return [User]
  attr_reader :user

  before_action do
    # @type [User]
    @user = current_user
  end

  def logged_in?
    !!@user
  end

  def require_admin_privileges
    current_user&.administrator? ? true : head(:unauthorized)
  end

  def require_mod_privileges
    current_user&.moderator? ? true : head(:unauthorized)
  end

  def raise_not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def require_login(api: false)
    return true if @user

    if api
      head :unauthorized
    else
      render_not_logged_in
    end
    false
  end

  def render_not_logged_in
    flash[:login] = true
    redirect_back fallback_location: '/#login'
  end

  private

  def current_user
    (User.find(session[:user_id]) if session[:user_id]) rescue (session[:user_id] = nil)
  end
end
