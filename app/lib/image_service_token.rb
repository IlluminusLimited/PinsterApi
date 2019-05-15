# frozen_string_literal: true

# Plays the role of CurrentUser but for the image service. So we are not a "user"
class ImageServiceToken
  attr_reader :decoded_token

  def initialize(decoded_token, _opts = {})
    @decoded_token = decoded_token
  end

  def to_current_user
    validate
    Rails.logger.debug { "Image service token granted!" }
    self
  end

  # Masquarade as a user because for pundit purposes we are.
  def user?
    true
  end

  def can?(_arg)
    false
  end

  def owns?(resource)
    return false unless resource.respond_to?(:id)

    resource.id == imageable_id && imageable_type.casecmp(resource.class.to_s).zero?
  end

  def imageable_type
    decoded_token['imageable_type']
  end

  def imageable_id
    decoded_token['imageable_id']
  end

  private

    def validate
      unless imageable_id && imageable_type
        Rails.logger.warn { "Image service token was missing imageable values! Token: #{decoded_token}" }
        raise JWT::InvalidPayload, "Missing required values in payload!"
      end
      true
    end
end
