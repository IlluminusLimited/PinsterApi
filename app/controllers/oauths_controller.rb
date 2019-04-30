# frozen_string_literal: true

class OauthsController < ApplicationController
  include Sorcery::Controller

  after_action :verify_authorized, except: %i[login oauth callback]

  api :GET, '/login', 'Get list of oauth providers'

  def login; end

  def logout
    reset_session
    redirect_to logout_url.to_s
  end

  # :nocov:
  api :GET, '/login/:provider', "Redirect to Oauth provider's flow"
  param :provider, String, desc: 'Oauth provider', required: true

  def oauth
    login_at(auth_params[:provider])
  end

  api :GET, '/oauth/callback', 'Callback url for Oauth provider'
  param :provider, String, desc: 'Oauth provider'

  def callback
    provider = auth_params[:provider]

    user = login_from(provider)
    user ||= auth_and_login(provider)

    token = user.authentications.find_by(provider: provider).refresh_token.token
    return  redirect_to((ENV['NATIVE_LOGIN_URI'] || root_url) + "/?token=#{token}") if provider == 'auth0'

    redirect_to((ENV['CLIENT_AUTH_CALLBACK_URL'] || root_url) + "/#{token}")
  end

  private

    def auth_and_login(provider)
      built_user = build_from(provider)
      user = User.find_by(email: built_user.email)

      user = user.presence || create_from(provider)
      reset_session # protect from session fixation attack
      auto_login(user)
      user
    end

    def auth_params
      params.permit(:provider, :code, :format)
    end
end
