# frozen_string_literal: true

require 'test_helper'

class ImageServiceTokenFactoryTest < ActiveSupport::TestCase
  def test_can_decode
    factory = TokenHelper.image_service_decoder
    imageable = pins(:texas_dragon)
    jwt = incoming_image_service_jwt(imageable)
    expected = ImageServiceToken.new("imageable_id" => imageable.id, "imageable_type" => imageable.class.to_s)
    assert_equal expected.decoded_token['imageable_id'], factory.call(jwt).decoded_token['imageable_id']
  end
end
