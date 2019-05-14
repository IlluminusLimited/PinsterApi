# frozen_string_literal: true

require 'base64'

module Utilities
  class ImageServiceJwt
    attr_reader :iss, :aud, :key

    def initialize(opts = {})

      private_key = Base64.urlsafe_decode64(ENV['PRIVATE_KEY'])
      image_service_key = Base64.urlsafe_decode64(ENV['IMAGE_SERVICE_PUBLIC_KEY'])
      logger.debug { "Private key: #{private_key.to_s}" }
      logger.debug("Image service public key: #{image_service_key}")
      @key = opts[:key] ||= OpenSSL::PKey::RSA.new(private_key)
      @image_service_public_key = opts[:image_service_public_key] ||= OpenSSL::PKey::RSA.new(image_service_key)
      @iss = opts[:iss] ||= ENV['JWT_AUD'] # Our JWT_AUD is our own uri, so when we encode tokens it's our ISS
      @aud = opts[:aud] ||= ENV['IMAGE_SERVICE_URL'] # The AUD of image service tokens is image service's URL
    end

    def generate_token(metadata, exp: 1.minute.from_now.to_i)
      payload = metadata.merge(iss: iss,
                               aud: aud,
                               nbf: (Time.now.to_i - 1),
                               exp: exp)
      JWT.encode(payload, @key, 'RS256')
    end

    # Used to check that our own tokens are valid.
    def double_check(token)
      JWT.decode(token,
                 @key.public_key,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: ENV['JWT_AUD'],
                 verify_iss: true,
                 aud: ENV['IMAGE_SERVICE_URL'],
                 verify_aud: true,
                 exp_leeway: 10,
                 nbf_leeway: 10)
    end

    def testing_token
      metadata = {
          imageable_id: "74bff7c0-529d-41a4-a1bb-f04fe182929c",
          imageable_type: "Pin",
          user_id: "1771dd50-2485-4569-af3a-c3a0849c5e32"
      }
      generate_token(metadata, exp: 8.hours.from_now.to_i)
    end

    def call(token)
      JWT.decode(token,
                 @image_service_public_key,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: ENV['IMAGE_SERVICE_URL'],
                 verify_iss: true,
                 aud: ENV['JWT_AUD'],
                 verify_aud: true,
                 exp_leeway: 10,
                 nbf_leeway: 10)
    end
  end
end
