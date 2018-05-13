# frozen_string_literal: true

class StaticController < ApplicationController
  after_action :verify_authorized, except: %i[legal]

  def legal; end
end
