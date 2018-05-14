# frozen_string_literal: true

module Tokenizer
  def self.encode(sub)
    payload = {
      iss: issuer,
      sub: sub,
      exp: 4.hours.from_now.to_i,
      iat: Time.now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def self.decode(token)
    options = {
      iss: issuer,
      verify_iss: true,
      verify_iat: true,
      leeway: 30,
      algorithm: 'HS256'
    }
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, options)
  end

  private

    def issuer
      ENV['JWT_URL']
    end
end
