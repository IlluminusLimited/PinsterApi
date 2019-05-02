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

    @current_user = CurrentUser.from_token(http_token)
  end

  def not_authenticated
    render status: :unauthorized, json: { "error": "Request missing required Authorization header." }
  end

  def user_not_authorized
    render status: :forbidden, json: { "error": "You are not authorized to perform this action." }
  end

  def http_token
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end
end
