class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      error: {
        title: 'Unprocessable Entity',
        details: resource.errors.full_messages
      }
    }, status: :unprocessable_entity
  end

  def not_found
    render json: {
      error: {
        status: '404',
        title: 'Not Found',
        details: 'The requested page could not be found.'
      }
    }, status: :not_found
  end

  def access_denied
    render json: {
      error: {
        status: '401',
        title: 'Access denied',
        details: 'You do not have the correct permissions.'
      }
    }, status: :unauthorized
  end

  private

  def current_account
    rodauth.rails_account
  end

  def authenticate
    rodauth.require_account # redirect to login page if not authenticated
  end
end
