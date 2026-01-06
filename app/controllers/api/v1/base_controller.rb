module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user!

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from ActionController::ParameterMissing, with: :parameter_missing

      private

      def authenticate_api_user!
        token = request.headers['Authorization']&.split(' ')&.last

        unless token
          render json: { error: 'Missing authentication token' }, status: :unauthorized
          return
        end

        @current_api_user = User.find_by_api_token(token)

        unless @current_api_user
          render json: { error: 'Invalid authentication token' }, status: :unauthorized
        end
      end

      def current_api_user
        @current_api_user
      end

      def record_not_found(exception)
        render json: {
          error: 'Record not found',
          message: exception.message
        }, status: :not_found
      end

      def record_invalid(exception)
        render json: {
          error: 'Validation failed',
          messages: exception.record.errors.full_messages
        }, status: :unprocessable_entity
      end

      def parameter_missing(exception)
        render json: {
          error: 'Parameter missing',
          message: exception.message
        }, status: :bad_request
      end
    end
  end
end
