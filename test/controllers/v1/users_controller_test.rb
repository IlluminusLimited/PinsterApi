# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "Admin can get index" do
    token = TokenHelper.for_user(users(:andrew), ['index:user'])
    get v1_users_url, headers: { Authorization: "Bearer " + token }

    assert_response :success
  end

  test "Anon cannot create user" do
    post v1_users_url, params: {
      data: {
        display_name: 'billy'
      }
    }, as: :json

    assert_response :unauthorized
  end

  test "User can be created" do
    sub = 'facebook|12341234'
    token = TokenHelper.generate_jwt(sub, [], (Time.now.in_time_zone + 20.minutes).to_i)

    post v1_users_url, headers: { Authorization: "Bearer " + token }, params: {
      data: {
        display_name: 'billy'
      }
    }, as: :json

    assert_response :created
    body = JSON.parse(response.body)

    assert_equal 'billy', body['display_name']
  end

  test "Duplicate user just returns original" do
    tom = users(:tom)
    token = TokenHelper.for_user(users(:tom))

    post v1_users_url, headers: { Authorization: "Bearer " + token }, params: {
      data: {
        display_name: 'billy'
      }
    }, as: :json

    assert_response :ok
    assert_equal tom.id, JSON.parse(response.body).fetch('id')
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
