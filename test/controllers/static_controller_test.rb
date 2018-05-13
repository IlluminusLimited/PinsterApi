# frozen_string_literal: true

require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get legal" do
    get static_legal_url
    assert_response :success
  end
end
