# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Auth
  include Pagination

  def record_not_unique(object)
    render status: :conflict, json: { "error": "Record not unique",
                                      "message": object.errors.to_json }
  end
end
