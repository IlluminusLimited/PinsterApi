# frozen_string_literal: true

require 'test_helper'

class OauthControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_url
    assert_response :success
  end
end
