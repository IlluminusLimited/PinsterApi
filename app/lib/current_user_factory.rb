# frozen_string_literal: true

class CurrentUserFactory
  attr_reader :logger, :token_verifier, :current_user, :user_finder

  def initialize(opts = {})
    @logger = opts[:logger] ||= Rails.logger
    @token_verifier = opts[:token_verifier] ||= Utilities::JsonWebToken
    @user_finder = opts[:user_finder] ||= ->(external_user_id) { User.find_by(external_user_id: external_user_id) }
    @current_user = opts[:current_user] ||= CurrentUser
  end

  def from_token(token)
    return current_user.new(User.anon_user) if token.nil?

    decoded_token = decode_token(token)
    external_user_id = decoded_token['sub']

    user = user_finder.call(external_user_id)
    build_user(user, external_user_id, decoded_token)
  end

  private

    def decode_token(token)
      decoded_token, _auth_header = token_verifier.call(token)
      decoded_token
    end

    def build_user(user, external_user_id, decoded_token)
      if user.nil?
        logger.warn { "No user with sub: #{external_user_id}" }
        return current_user.new(User.anon_user)
      end

      current_user.new(user).with_permissions(decoded_token['permissions'])
    end
end
