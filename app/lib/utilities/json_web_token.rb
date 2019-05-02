# frozen_string_literal: true

require 'net/http'
require 'uri'

module Utilities
  module JsonWebToken
    def self.verify(token)
      JWT.decode(token, nil,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: ENV['oa_auth0_site'] + '/',
                 verify_iss: true,
                 aud: ENV['auth0_audience'],
                 verify_aud: true) do |header|
        jwks_hash[header['kid']]
      end
    end

    # TODO: Cache this
    def self.jwks_hash
      Rails.logger.debug { "Fetching jwks.json from auth0" }
      jwks_raw = Net::HTTP.get URI("https://dev-pinster-illuminusltd.auth0.com/.well-known/jwks.json")
      jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
      Hash[
          jwks_keys.map do |key|
            [key['kid'], OpenSSL::X509::Certificate.new(Base64.decode64(key['x5c'].first)).public_key]
          end
      ]
    end
  end
end
