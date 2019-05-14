# frozen_string_literal: true

module Utilities
  class TokenFactoryResolver
    def initialize(opts = {})
      @decoders = opts[:decoders] ||= { "#{ENV['AUTH0_SITE']}/" => Utilities::Auth0TokenFactory,
                                        (ENV['IMAGE_SERVICE_URL']).to_s => Utilities::ImageServiceTokenFactory.new }
      @iss_decoder = opts[:iss_decoder] ||= ->(token) { JWT.decode(token, false, nil).first['iss'] }
    end

    def call(token)
      look_up_decoder(token).call(token)
    end

    private

      def look_up_decoder(token)
        iss = @iss_decoder.call(token)
        decoder = @decoders[iss]
        raise JWT::InvalidIssuerError, "Could not find validator for iss: '#{iss}'" unless decoder

        decoder
      end
  end
end
