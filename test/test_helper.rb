# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
require 'minitest/reporters'
require 'minitest/ci'

Minitest::Ci.report_dir = File.expand_path('../tmp/test-results', __dir__)

SimpleCov.coverage_dir(File.expand_path('../tmp/coverage/backend', __dir__))

SimpleCov.start 'rails'

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'policy_assertions'

require 'test_helpers/token_helper'
require 'test_helpers/policy_test_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
