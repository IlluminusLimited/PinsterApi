# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Auth
  include Pagination
end
