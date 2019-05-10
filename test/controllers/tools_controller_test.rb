# frozen_string_literal: true

require 'test_helper'
require 'digest'
require 'base64'

class ToolsControllerTest < ActionDispatch::IntegrationTest
  test "code_challenge generates url_safe" do
    post tools_crypto_codes_url
    assert_response :ok
    assert_not response.body.blank?
    body = JSON.parse(response.body)
    challenge = body['code_challenge']
    verifier = body['code_verifier']

    hashed_verifier = Digest::SHA256.hexdigest(verifier)
    decoded_challenge = Base64.urlsafe_decode64(challenge)
    assert_equal hashed_verifier, decoded_challenge
  end
end
