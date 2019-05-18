# frozen_string_literal: true

require 'uri'
require 'net/http'

module Utilities
  class Auth0TokenFactory
    def initialize(opts = {})
      @jwt_decoder = opts[:jwt_decoder] ||= Auth0TokenDecoder
    end

    def call(jwt)
      decoded = @jwt_decoder.call(jwt).first
      Auth0Token.new(decoded)
    end
  end

  module Auth0TokenDecoder
    def self.call(jwt)
      @jwks_hash ||= jwks_hash
      # Returns an array of decoded_body, header. We don't care about the token header so we'll just get .first
      JWT.decode(jwt, nil,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: ENV['AUTH0_SITE'] + '/',
                 verify_iss: true,
                 aud: ENV['JWT_AUD'],
                 verify_aud: true) do |header|
        @jwks_hash[header['kid']]
      end
    end

    def self.jwks_hash
      Rails.logger.warn { "Fetching jwks.json from auth0" }
      jwks_raw = Net::HTTP.get URI("#{ENV['AUTH0_SITE']}/.well-known/jwks.json")
      jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
      Hash[
          jwks_keys.map do |key|
            [key['kid'], OpenSSL::X509::Certificate.new(Base64.decode64(key['x5c'].first)).public_key]
          end
      ]
    end
  end
end
