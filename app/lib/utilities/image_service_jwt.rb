# frozen_string_literal: true

require 'uri'
require 'net/http'
module Utilities
  module ImageServiceJwt
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
