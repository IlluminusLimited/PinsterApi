# frozen_string_literal: true

require 'test_helper'

class OauthControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_url
    assert_response :success
  end

  test 'a user can be created from oauth callback' do
    # params = { "provider" => "google", "code" => "gibberish" }
    #Without a way to mock the oauth2 client I can't write this test
    # assert_difference('User.count') do
    #   get oauth_callback_url params: params
    # end
  end
end
