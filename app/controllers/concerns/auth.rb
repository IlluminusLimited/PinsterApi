# frozen_string_literal: true

module Auth
  extend ActiveSupport::Concern
  include Pundit

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from JWT::DecodeError, with: :token_error
    rescue_from JWT::ExpiredSignature, with: :token_error
    rescue_from JWT::InvalidIssuerError, with: :token_error
    rescue_from JWT::InvalidIatError, with: :token_error

    after_action :verify_authorized
  end

  def require_login
    not_authenticated unless logged_in?
  end

  def logged_in?
    current_user.user?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = current_user_factory.from_token(http_token)
  end

  def token_error(exception)
    logger.warn { "Token error: #{exception.message}" }
    render status: :forbidden, json: { "error": "Request missing valid Authorization header.",
                                       "message": truncate_error_message(exception.message) }
  end

  def not_authenticated
    render status: :unauthorized, json: { "error": "Request missing valid Authorization header." }
  end

  def user_not_authorized
    render status: :forbidden, json: { "error": "You are not authorized to perform this action." }
  end

  def http_token
    request.headers['Authorization'].slice(7..-1) if request.headers['Authorization'].present?
  end

  def current_user_factory
    @@current_user_factory ||= CurrentUserFactory.new
  end

  def truncate_error_message(message)
    @@exception_message_handler ||= ->(msg) { msg.split('.')&.first }
    @@exception_message_handler.call(message)
  end

  # For testing use only
  def self.current_user_factory=(current_user_factory)
    @@current_user_factory = current_user_factory
  end

  def self.exception_message_handler=(exception_message_handler)
    @@exception_message_handler = exception_message_handler
  end
end
