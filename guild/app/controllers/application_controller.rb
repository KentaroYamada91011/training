class ApplicationController < ActionController::Base
  require 'logic_maintenance'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action -> { check_maintenance }

  def check_maintenance
    if controller_name != 'maintenance' && LogicMaintenance.doing?
      redirect_to controller: :maintenance, action: :index
    end
  end
end