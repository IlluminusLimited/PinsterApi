# frozen_string_literal: true

require 'test_helper'

class TokenVerifierTest < ActiveSupport::TestCase
  def test_can_look_up_verifier
    assert_equal "yay", Utilities::TokenVerifier.new(verifiers: { "bob" => proc { "yay" } },
                                                     iss_decoder: proc { "bob" }).call('some token')
  end

  def test_blows_up_when_no_iss_match
    assert_raises(JWT::InvalidIssuerError) do
      Utilities::TokenVerifier.new(verifiers: { "bob" => proc { "yay" } },
                                   iss_decoder: proc { "no match" }).call('some token')
    end
  end

  def test_blows_up_when_no_verifiers
    assert_raises(JWT::InvalidIssuerError) do
      Utilities::TokenVerifier.new(verifiers: {},
                                   iss_decoder: proc { "no match" }).call('some token')
    end
  end

  def test_actually_works
    key = OpenSSL::PKey::RSA.generate(2048)
    iss = 'bob'
    aud = 'lob'
    payload = { "data" => "howdy", "iss" => iss, "aud" => aud }

    verifier = lambda do |token|
      JWT.decode(token, key.public_key, true, algorithm: 'RS256',
                                              iss: iss, verify_iss: true, aud: aud, verify_aud: true)
    end

    token_verifier = Utilities::TokenVerifier.new(verifiers: { iss => verifier })
    assert_equal([payload, { "alg" => "RS256" }], token_verifier.call(JWT.encode(payload, key, 'RS256')))
  end
end
