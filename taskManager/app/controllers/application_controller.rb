class ApplicationController < ActionController::Base
  before_action :store_location
  before_action :check_session
  rescue_from ActionController::RoutingError, with: :error_404
  rescue_from Exception, with: :error_500
  helper_method :sort_column, :sort_direction

  include CommonLogin
  include LoginHelper

  def error_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def error_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  private

  def check_session
    return redirect_to(:controller => '/login',:action => 'index') unless logged_in?
  end

  def store_location
    session[:return_to] = request.url
  end
  
  def authenticate_user
    return redirect_to(:controller => 'login',:action => 'index') unless valid_session?
  end

  def make_simple_message(column: 'task' , action:, result: true)
    result_str = "words.failure"
    result_str = "words.success" if result

    I18n.t("messages.simple_result",
      name: I18n.t("words.#{column}"),
      action: I18n.t("actions.#{action}"),
      result: I18n.t(result_str))
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : ''
  end
end
