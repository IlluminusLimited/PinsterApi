# frozen_string_literal: true

require 'test_helper'

class Auth0TokenFactoryTest < ActiveSupport::TestCase
  def test_can_decode_token
    factory = Utilities::Auth0TokenFactory.new(jwt_decoder: TokenHelper.jwt_decoder)
    jwt = TokenHelper.generate_jwt('bob')
    expected = Auth0Token.new('sub' => 'bob')
    assert_equal expected.external_user_id, factory.call(jwt).external_user_id
  end
end
