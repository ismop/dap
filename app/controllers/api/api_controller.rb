module Api
  class ApiController < ActionController::Base
    protect_from_forgery with: :null_session
    check_authorization

    include Filterable

    rescue_from CanCan::AccessDenied do |exception|
      if current_user.nil?
        render json: {message: '401 Unauthorized'}, status: :unauthorized
      else
        render json: {message: '403 Forbidden'}, status: :forbidden
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: {message: 'Record not found'}, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |exception|
      render json: {message: exception.to_s}, status: :unprocessable_entity
    end


    rescue_from ActiveRecord::RecordInvalid do |exception|
      render_error exception.record
    end

    rescue_from ActionController::BadRequest do |exception|
      render json: {message: exception.to_s}, status: :bad_request
    end

    protected
    def render_error(model_obj)
      render json: model_obj.errors, status: :unprocessable_entity
    end

  end

end