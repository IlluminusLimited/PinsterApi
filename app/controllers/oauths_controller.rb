# frozen_string_literal: true

class OauthsController < ApplicationController
  include Sorcery::Controller

  after_action :verify_authorized, except: %i[login oauth callback]

  api :GET, '/login', 'Get list of oauth providers'
  def login; end

  # :nocov:
  api :GET, '/login/:provider', "Redirect to Oauth provider's flow"
  param :provider, String, desc: 'Oauth provider', required: true
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    user = login_from(provider)
    user ||= auth_and_login(provider)

    @token = user.authentications.find_by(provider: provider).refresh_token
  end

  private

    def auth_and_login(provider)
      user = create_from(provider)
      reset_session # protect from session fixation attack
      auto_login(user)
      user
    end

    def auth_params
      params.permit(:provider, :code)
    end
end
