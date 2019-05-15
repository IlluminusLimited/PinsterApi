# frozen_string_literal: true

require 'openssl'
require 'base64'

module Utilities
  class TokenGenerator
    attr_reader :key, :iss, :aud

    def initialize(opts = {})
      @key = opts[:key] ||= OpenSSL::PKey::RSA.new(Base64.urlsafe_decode64(ENV['PRIVATE_KEY']))
      @iss = opts[:iss] ||= ENV['JWT_AUD'] # Our JWT_AUD is our own uri, we are ISSUING tokens for the AUD to consume
      @aud = opts[:aud] ||= ENV['IMAGE_SERVICE_URL'] # The AUD of procuded image service tokens is image service's URL
    end

    # Generate a JWT using our own private key that image service has a public key for.
    # This token is meant to be given to a client and can be used to create images for a given imageable
    def generate_jwt(metadata, exp: 10.minutes.from_now.to_i)
      payload = metadata.merge(iss: iss,
                               aud: aud,
                               nbf: (Time.now.to_i - 1),
                               exp: exp)
      JWT.encode(payload, @key, 'RS256')
    end

    # Used to check that our own tokens are valid.
    def manual_jwt_check(token)
      JWT.decode(token,
                 @key.public_key,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: iss,
                 verify_iss: true,
                 aud: aud,
                 verify_aud: true,
                 exp_leeway: 10,
                 nbf_leeway: 10)
    end

    # Only used for testing
    def ____generate_testing_token
      metadata = {
        imageable_id: "74bff7c0-529d-41a4-a1bb-f04fe182929c",
        imageable_type: "Pin",
        user_id: "1771dd50-2485-4569-af3a-c3a0849c5e32"
      }
      generate_jwt(metadata, exp: 8.hours.from_now.to_i)
    end
  end
end
