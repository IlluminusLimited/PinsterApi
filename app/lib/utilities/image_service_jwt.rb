# frozen_string_literal: true

module Utilities
  class ImageServiceJwt
    attr_reader :iss, :aud

    def initialize(opts = {})
      @key = opts[:key] ||= OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'].undump)
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

    def self.call(token)
      @public_key ||= OpenSSL::PKey::RSA.new(ENV['IMAGE_SERVICE_PUBLIC_KEY'].undump)
      JWT.decode(token,
                 @public_key,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: ENV['IMAGE_SERVICE_URL'],
                 verify_iss: true,
                 aud: ENV['JWT_AUD'],
                 verify_aud: true)
    end
  end
end
