# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Sorcery::Controller

  def current_user
    return @current_user if defined?(@current_user)

    auth = Authentication.find_by(token: request.headers['Authorization']&.gsub('Bearer ', ''))

    return nil unless auth.present? && auth.token_valid?
    auth&.user
  end

  def not_authenticated
    render status: :unauthorized, json: { "error": "Request missing required Authorization header." }
  end
end
