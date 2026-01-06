module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_api_user!, only: [:login, :register]

      # POST /api/v1/auth/register
      def register
        @user = User.new(user_params)

        if @user.save
          render json: {
            message: 'User successfully registered',
            user: user_json(@user),
            api_token: @user.api_token
          }, status: :created
        else
          render json: {
            error: 'Registration failed',
            messages: @user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])
          render json: {
            message: 'Login successful',
            user: user_json(@user),
            api_token: @user.api_token
          }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      # POST /api/v1/auth/logout
      def logout
        current_api_user.regenerate_api_token
        render json: { message: 'Logout successful' }, status: :ok
      end

      # GET /api/v1/auth/me
      def me
        render json: user_json(current_api_user), status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          role: user.role,
          created_at: user.created_at
        }
      end
    end
  end
end
