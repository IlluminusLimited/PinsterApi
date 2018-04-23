# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "Sally's token returns unauthorized" do
    sally_token = authentications(:sally_token)
    get v1_user_url(users(:sally).id), headers: { Authorization: sally_token.token }

    assert_response :unauthorized
  end

  test "Tom can get index" do
    tom_token = authentications(:tom_token)
    get v1_users_url, headers: { Authorization: tom_token.token }

    assert_response :success
  end

  test "Tom can get his user info" do
    tom_token = authentications(:tom_token)
    get v1_user_url(users(:tom).id), headers: { Authorization: tom_token.token }

    assert_response :success
  end
end
