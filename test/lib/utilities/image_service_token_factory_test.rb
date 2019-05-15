# frozen_string_literal: true

require 'test_helper'

class ImageServiceTokenFactoryTest < ActiveSupport::TestCase
  def test_can_encode_and_decode
    factory = generate_factory
    jwt = factory.generate_jwt("imageable_id" => 1, "imageable_type" => '2')
    expected = ImageServiceToken.new("imageable_id" => 1, "imageable_type" => '2')
    assert_equal expected.decoded_token['imageable_id'], factory.call(jwt).decoded_token['imageable_id']
  end

  private

    def generate_factory
      Utilities::ImageServiceTokenFactory.new(key: TokenHelper::PRIVATE_KEY,
                                              image_service_public_key: TokenHelper::PUBLIC_KEY,
                                              iss: 'http://127.0.0.1:3000',
                                              aud: 'yo momma')
    end
end
