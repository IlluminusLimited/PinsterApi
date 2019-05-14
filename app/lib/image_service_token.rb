# frozen_string_literal: true

class ImageServiceToken
  def initialize(decoded_token, opts = {})
    @decoded_token = decoded_token
  end

  def to_current_user
    logger.debug { "Image service token granted!" }
  end

  # Used to differentiate users from services using JWTs to talk to our api
  def service?
    true
  end

  def owns?(resource)
    return false unless resource.respond_to?(:user_id)

    resource.user_id == id
  end
end
