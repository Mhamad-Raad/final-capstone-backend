# app/controllers/api/v1/sessions_controller.rb

module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :authenticate_request

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          auth_token = JsonWebToken.encode(user_id: user.id)
          render json: { auth_token: }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
