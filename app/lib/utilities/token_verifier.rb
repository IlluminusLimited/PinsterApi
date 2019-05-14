# frozen_string_literal: true

module Utilities
  class TokenVerifier
    def initialize(opts = {})
      @verifiers = opts[:verifiers] ||= { "#{ENV['AUTH0_SITE']}/" => Utilities::Auth0Jwt,
                                          (ENV['IMAGE_SERVICE_URL']).to_s => Utilities::ImageServiceJwt.new }
      @iss_decoder = opts[:iss_decoder] ||= ->(token) { JWT.decode(token, false, nil).first['iss'] }
    end

    def call(token)
      look_up_verifier(token).call(token)
    end

    private

      def look_up_verifier(token)
        iss = @iss_decoder.call(token)
        verifier = @verifiers[iss]
        raise JWT::InvalidIssuerError, "Could not find validator for iss: '#{iss}'" unless verifier

        verifier
      end
  end
end
