# frozen_string_literal: true

class ImageServiceClient
  include HTTParty
  attr_reader :token_generator, :image_service_url

  def initialize(opts = {})
    @image_service_url = opts[:image_service_url] ||= ENV['IMAGE_SERVICE_URL']
    @token_generator = opts[:token_generator] ||= Utilities::ImageServiceJwt.new
  end

  def upload_image(encoded_image, imageable)
    metadata = { imageable_id: imageable.id,
                 imageable_type: imageable.class.to_s }
    token = token_generator.generate_token(metadata)
    response = HTTParty.post(image_service_url, body: { data: { image: encoded_image } },
                                                headers: { Authorization: "Bearer #{token}" })
  end
end
