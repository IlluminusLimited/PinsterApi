# frozen_string_literal: true

task generate_keys: :environment do
  require 'openssl'
  require 'base64'

  logger = Logger.new(STDOUT)
  logger.info { "Generating keys!" }

  api_key = OpenSSL::PKey::RSA.generate(2048)
  encoded_private = Base64.urlsafe_encode64(api_key.to_s)
  encoded_public = Base64.urlsafe_encode64(api_key.public_key.to_s)


  image_service_key = OpenSSL::PKey::RSA.generate(2048)
  image_service_encoded_private = Base64.urlsafe_encode64(image_service_key.to_s)
  image_service_encoded_public = Base64.urlsafe_encode64(image_service_key.public_key.to_s)


  output = ["PRIVATE_Key=#{encoded_private}",
            "PUBLIC_KEY=#{encoded_public}",
            "IMAGE_SERVICE_PRIVATE_KEY=#{image_service_encoded_private}",
            "IMAGE_SERVICE_PUBLIC_KEY=#{image_service_encoded_public}"]
               .join("\n")

  File.open(Rails.root.join("keys.env"), 'w') do |f|
    f.puts output
  end
  logger.info "Done!"
end
