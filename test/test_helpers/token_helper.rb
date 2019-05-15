# frozen_string_literal: true

module TokenHelper
  ISS = "http://auth0.stuff:3000/"
  AUD = "http://localhost:3000"

  PRIVATE_KEY = OpenSSL::PKey::RSA.generate(2048)
  PUBLIC_KEY = PRIVATE_KEY.public_key

  IMAGE_SERVICE_URL = "http://image-service"

  class << self
    def resolver
      Utilities::TokenFactoryResolver.new(decoders: {
                                            ISS => auth0_decoder,
                                            IMAGE_SERVICE_URL => image_service_decoder
                                          })
    end

    def auth0_decoder
      Utilities::Auth0TokenFactory.new(jwt_decoder: TokenHelper.jwt_decoder)
    end

    def image_service_decoder
      Utilities::ImageServiceTokenFactory.new(public_key: PUBLIC_KEY,
                                              iss: IMAGE_SERVICE_URL,
                                              aud: AUD)
    end

    def image_service_jwt_generator
      Utilities::TokenGenerator.new(iss: IMAGE_SERVICE_URL, aud: AUD, key: PRIVATE_KEY)
    end

    def for_user(user, permissions = [], exp = 1.minute.from_now.to_i)
      generate_jwt(user.external_user_id, permissions, exp)
    end

    def generate_jwt(sub, permissions = [], exp = 1.minute.from_now.to_i)
      payload = {
        "iss": ISS,
        "sub": sub,
        "aud": [AUD],
        "iat": (Time.now.in_time_zone - 1.hour).to_i,
        "exp": exp,
        "scope": "openid profile email",
        "permissions": permissions
      }

      JWT.encode payload, PRIVATE_KEY, 'RS256'
    end

    def jwt_decoder
      lambda do |jwt|
        JWT.decode(jwt,
                   PUBLIC_KEY,
                   true, # Verify the signature of this token
                   algorithm: 'RS256',
                   iss: ISS,
                   verify_iss: true,
                   aud: AUD,
                   verify_aud: true)
      end
    end
  end
end
