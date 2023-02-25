# app/controllers/api/api_controller.rb
# require_relative '../commands/authorize_api_request'

module Api
  class ApiController < ActionController::API
    include ExceptionHandler
    # before_action :authenticate_request

    private

    def authenticate_request
      header = request.headers['Authorization']
      if header && header.split.first == 'Bearer'
        token = header.split.last
        begin
          decoded = JsonWebToken.decode(token)
          @current_user = User.find(decoded[:user_id])
        rescue JWT::DecodeError
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      else
        render json: { error: 'Missing token' }, status: :unauthorized
      end
    end

    attr_reader :current_user
  end
end
