class SessionsController < ApplicationController
  before_action :check_user, only: [:create]
  skip_before_action :login_required

  def new
  end

  def create
    if @user.authenticate(session_params[:password])
      sign_in(@user)
      redirect_to root_path
    else
      flash.now[:alert] = t('.flash.invalid_password')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: t('.flash.logout')
  end

  private

  def check_user
    unless @user = User.find_by(email: session_params[:email])
      flash.now[:alert] = t('.flash.invalid_mail')
      render action: 'new'
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
