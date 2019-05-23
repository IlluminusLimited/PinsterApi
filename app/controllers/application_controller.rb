# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Auth
  include Pagination

  rescue_from Apipie::Error, with: :apipie_error

  def apipie_error(error)
    render status: :unprocessable_entity, json: { "error": "Apipie validation error",
                                                  "message": error.message }
  end
end
