# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "Admin can get index" do
    token = authentications(:andrew_token)
    get v1_users_url, headers: { Authorization: token.token }

    assert_response :success
  end

  test "Tom can get his user info" do
    tom_token = authentications(:tom_token)
    get v1_user_url(users(:tom)), headers: { Authorization: tom_token.token }

    assert_response :success
  end
end
