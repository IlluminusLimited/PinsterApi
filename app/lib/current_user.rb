# frozen_string_literal: true


class CurrentUser < SimpleDelegator
  def self.from_token(token)
    decoded_token, auth_header = Utilities::JsonWebToken.verify(token)
    Rails.logger.debug { "Decoded token: #{decoded_token}" }
    Rails.logger.debug { "Token auth header: #{auth_header}" }

    external_user_id = decoded_token['sub']
    Rails.logger.debug { "Looking up user with sub: #{external_user_id}" }

    user = User.find_by(external_user_id: external_user_id)
    user.nil? ?
        Rails.logger.debug { "No user found with sub: #{external_user_id}" } :
        Rails.logger.debug { "Found user was: #{user}" }
    user ? CurrentUser.new(user) : CurrentUser.new(User.anon_user)
  end
end
