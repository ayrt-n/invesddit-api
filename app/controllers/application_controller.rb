class ApplicationController < ActionController::Base
  before_action :set_current_account
  before_action :set_active_storage_current_host

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # Format of successful response { "data" : ... }
  def render_resource(resource)
    render json: { data: resource }
  end

  # Error responses
  def unprocessable_entity(resource)
    render json: {
      error: {
        code: '422',
        message: 'Unprocessable Entity',
        details: resource.errors.full_messages
      }
    }, status: :unprocessable_entity
  end

  def not_found
    render json: {
      error: {
        code: '404',
        message: 'Not Found',
        details: ['The requested resource could not be found.']
      }
    }, status: :not_found
  end

  def access_denied
    render json: {
      error: {
        code: '401',
        message: 'Access denied',
        details: ['You do not have the correct permissions.']
      }
    }, status: :unauthorized
  end

  # Sanitize pagination params by transforming to integer if provided
  def sanitize_pagination_params
    params[:page] = params[:page].to_i if params[:page]
    params[:limit] = params[:limit].to_i if params[:limit]
  end

  # Set the host for active storage, used when generating urls
  def set_active_storage_current_host
    ActiveStorage::Current.url_options = {
      protocol: request.protocol,
      host: request.host,
      port: request.port
    }
  end

  private

  # Set current_account instance variable if logged in
  def set_current_account
    @current_account = rodauth.rails_account
  end

  # Authenticate logged in
  def authenticate
    rodauth.require_account
  end
end
