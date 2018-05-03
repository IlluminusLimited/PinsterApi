# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'policy_assertions'
require 'test_helpers/policy_test_helper'
require 'simplecov'
require 'minitest/ci'

Minitest::Ci.report_dir = Rails.root.join('tmp', 'test-results')

SimpleCov.coverage_dir(Rails.root.join('tmp', 'coverage', 'backend'))

SimpleCov.start

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
