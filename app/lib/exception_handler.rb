# app/exceptions/exception_handler.rb

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ExceptionHandler::MissingToken do |_e|
      json_response({ msg: 'Unable to process', error: { value: 'Missing Token', details: [] } }, :unprocessable_entity)
    end

    rescue_from ExceptionHandler::InvalidToken do |_e|
      json_response({ msg: 'Unable to process', error: { value: 'Invalid Token', details: [] } }, :unprocessable_entity)
    end

    rescue_from ActionController::ParameterMissing do |e|
      json_response({ msg: 'Unable to process', error: { value: 'Required parameters missing', details: e.message } },
                    :unprocessable_entity)
    end
  end

  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  def json_response(payload, status)
    render json: payload, status:
  end
end
