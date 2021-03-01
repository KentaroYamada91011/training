# frozen_string_literal: true

module Session
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def check_login_user
    redirect_to login_url unless logged_in?
  end
end
