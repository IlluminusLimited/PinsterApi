# frozen_string_literal: true

module Utilities
  class TokenFactoryResolver
    attr_reader :decoders
    def initialize(opts = {})
      @decoders = opts[:decoders] ||= { "#{ENV['AUTH0_SITE']}/" => Utilities::Auth0TokenFactory.new,
                                        (ENV['IMAGE_SERVICE_URL']).to_s => Utilities::ImageServiceTokenFactory.new }
      @iss_decoder = opts[:iss_decoder] ||= ->(token) { JWT.decode(token, false, nil).first['iss'] }
    end

    # Look up decoder then call it.
    def call(jwt)
      iss = @iss_decoder.call(jwt)
      decoder = @decoders[iss]
      raise JWT::InvalidIssuerError, "Could not find validator for iss: '#{iss}'" unless decoder

      decoder.call(jwt)
    end
  end
end
