class Api::ApiController < ActionController::API
  include ExceptionHandler
  # before_action :authorize_request, except: %i[login signup]

  def not_found
    render json: { msg: 'Unable to access token', error: 'Token not found' }, status: :unauthorized
  end

  # rubocop:disable Lint/UselessAssignment
  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      not_found
    end
  end
  # rubocop:enable Lint/UselessAssignment
end
