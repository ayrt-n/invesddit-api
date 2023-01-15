class ApplicationController < ActionController::Base
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource, status: :created
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

  private

  def authenticate
    rodauth.require_account # redirect to login page if not authenticated
  end
end
