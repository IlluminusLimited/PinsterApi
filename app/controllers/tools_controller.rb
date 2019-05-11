# frozen_string_literal: true

require 'securerandom'
require 'base64'
require 'digest'

class ToolsController < ApplicationController
  after_action :verify_authorized, except: :crypto_codes
  api :POST, "/tools/crypto_codes", "Generate crypto_codes"
  show false

  def crypto_codes
    raw_verifier = SecureRandom.random_bytes(32)
    code_verifier = Base64.urlsafe_encode64(raw_verifier, padding: false)
    code_challenge = Base64.urlsafe_encode64(Digest::SHA256.hexdigest(code_verifier), padding: false)
    render status: :ok, json: { "code_verifier": code_verifier, "code_challenge": code_challenge }
  rescue StandardError => e
    logger.error { "Error while generating crypto_codes: #{e.message}. Cause: #{e.cause}" }
    render status: :internal_server_error, json: { "error": "An error occurred while generating keys." }
  end
end
