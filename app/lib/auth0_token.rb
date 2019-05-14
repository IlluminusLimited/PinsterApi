# frozen_string_literal: true

class Auth0Token
  attr_reader :decoded_token

  def initialize(decoded_token, opts = {})
    @decoded_token = decoded_token
    @user_finder = opts[:user_finder] ||= ->(external_user_id) { User.find_by(external_user_id: external_user_id) }
    @current_user = opts[:current_user] ||= CurrentUser
  end

  def to_current_user
    external_user_id = decoded_token['sub']

    user = @user_finder.call(external_user_id)
    build_user(user, external_user_id, decoded_token)
  end

  private

    def build_user(user, external_user_id, decoded_token)
      if user.nil?
        logger.warn { "No user with sub: #{external_user_id}" }
        return @current_user.new(User.anon_user)
      end

      @current_user.new(user).with_permissions(decoded_token['permissions'])
    end
end
