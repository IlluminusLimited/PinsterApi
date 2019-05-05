# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "Admin can get index" do
    token = TokenHelper.for_user(users(:andrew), ['index:user'])
    get v1_users_url, headers: { Authorization: "Bearer " + token }

    assert_response :success
  end

  test "Tom can get his user info" do
    token = TokenHelper.for_user(users(:tom))

    get v1_user_url(users(:tom)), headers: { Authorization: "Bearer " + token }

    assert_response :success
  end

  test "Admin can destroy user" do
    token = TokenHelper.for_user(users(:andrew), ['destroy:user'])
    delete v1_user_url(users(:tom)), headers: { Authorization: "Bearer " + token }

    assert_response :success
  end
end
