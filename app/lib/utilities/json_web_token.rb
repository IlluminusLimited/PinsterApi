# frozen_string_literal: true

require 'uri'
require 'net/http'

module Utilities
  module JsonWebToken
    def self.call(token)
      @jwks_hash ||= jwks_hash
      JWT.decode(token, nil,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: ENV['oa_auth0_site'] + '/',
                 verify_iss: true,
                 aud: ENV['auth0_audience'],
                 verify_aud: true) do |header|
        @jwks_hash[header['kid']]
      end
    end

    def self.jwks_hash
      Rails.logger.warn { "Fetching jwks.json from auth0" }
      jwks_raw = Net::HTTP.get URI("#{ENV['oa_auth0_site']}/.well-known/jwks.json")
      jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
      Hash[
          jwks_keys.map do |key|
            [key['kid'], OpenSSL::X509::Certificate.new(Base64.decode64(key['x5c'].first)).public_key]
          end
      ]
    end
  end
end
