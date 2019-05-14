# frozen_string_literal: true

module Utilities
  class ImageServiceJwt
    attr_reader :iss, :aud, :key

    def initialize(opts = {})
      @key = opts[:key] ||= OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'])
      @image_service_public_key = opts[:image_service_public_key] ||=
                                    OpenSSL::PKey::RSA.new(ENV['IMAGE_SERVICE_PUBLIC_KEY'])
      @iss = opts[:iss] ||= ENV['JWT_AUD'] # Our JWT_AUD is our own uri, so when we encode tokens it's our ISS
      @aud = opts[:aud] ||= ENV['IMAGE_SERVICE_URL'] # The AUD of image service tokens is image service's URL
    end

    def generate_token(metadata)
      payload = metadata.merge(iss: iss,
                               aud: aud,
                               nbf: (Time.now.to_i - 1),
                               exp: 1.minute.from_now.to_i)
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

    def validate_image_service_token(token)
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
