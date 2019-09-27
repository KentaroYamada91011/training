# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  rescue_from Exception,                        with: :render_500
  rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  rescue_from ActionController::RoutingError,   with: :render_404

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render file: "#{Rails.root}/public/404.html", content_type: 'text/html', status: :not_found
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", content_type: 'text/html', status: :internal_server_error
  end
end