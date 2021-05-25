class LogoutController < ApplicationController
  def destroy
    reset_session
    redirect_to login_path(I18n.locale)
  end
end
