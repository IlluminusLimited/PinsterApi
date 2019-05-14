# frozen_string_literal: true

require 'uri'
require 'net/http'

module Utilities
  module Auth0TokenFactory

    def from_jwt(jwt)
      Auth0Token.new(decode_jwt(jwt))
    end

    private

      def decode_jwt(jwt)
        @jwks_hash ||= jwks_hash
        JWT.decode(token, nil,
                   true, # Verify the signature of this token
                   algorithm: 'RS256',
                   iss: ENV['AUTH0_SITE'] + '/',
                   verify_iss: true,
                   aud: ENV['JWT_AUD'],
                   verify_aud: true) do |header|
          @jwks_hash[header['kid']]
        end
      end

      def jwks_hash
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
