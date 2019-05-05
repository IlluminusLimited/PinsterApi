# frozen_string_literal: true

class CurrentUserFactory
  attr_reader :logger, :token_verifier, :current_user

  def initialize(opts = {})
    @logger = opts[:logger] ||= Rails.logger
    @token_verifier = opts[:token_verifier] ||= Utilities::JsonWebToken
    @current_user = opts[:current_user] ||= CurrentUser
  end

  def from_token(token)
    decoded_token = decode_token(token)
    external_user_id = decoded_token['sub']
    logger.debug { "Looking up user with sub: #{external_user_id}" }

    user = User.find_by(external_user_id: external_user_id)
    build_user(user, external_user_id, decoded_token)
  end

  private

    def decode_token(token)
      decoded_token, auth_header = token_verifier.call(token)
      logger.debug { "Decoded token: #{decoded_token}" }
      logger.debug { "Token auth header: #{auth_header}" }
      decoded_token
    end

    def build_user(user, external_user_id, decoded_token)
      if user.nil?
        logger.debug { "No user with sub: #{external_user_id}" }
        return current_user.new(User.anon_user)
      end

      logger.debug { "Found user was: #{user}" }
      current_user.new(user).with_permissions(decoded_token['permissions'])
    end
end
