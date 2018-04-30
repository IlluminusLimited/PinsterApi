# frozen_string_literal: true

module Auth
  extend ActiveSupport::Concern
  include Pundit

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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

    auth = Authentication.find_by(token: request.headers['Authorization']&.gsub('Bearer ', ''))

    @current_user = auth&.token_valid? ?  auth.user : User.anon_user
  end

  def not_authenticated
    render status: :unauthorized, json: { "error": "Request missing required Authorization header." }
  end

  def user_not_authorized
    render status: :forbidden, json: { "error": "You are not authorized to perform this action." }
  end
end
