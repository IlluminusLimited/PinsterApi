# frozen_string_literal: true

require 'test_helper'

class MeControllerTest < ActionDispatch::IntegrationTest
  test "no token returns unauthorized" do
    get v1_me_url
    assert_response :unauthorized
  end

  test "Sallys expired token returns forbidden" do
    token = TokenHelper.for_user(users(:sally), [], (Time.now.in_time_zone - 30.minutes).to_i)
    get v1_me_url, headers: { Authorization: "Bearer " + token }

    assert_response :forbidden
  end

  test "should show me" do
    tom = users(:tom)
    token = TokenHelper.for_user(tom)
    get v1_me_url, headers: { Authorization: "Bearer " + token }, as: :json

    assert_response :success
    assert_not response.body.blank?
    body = JSON.parse(response.body)
    assert_equal tom.display_name, body['display_name']
    assert_equal tom.bio, body['bio']
  end

  test "should update me" do
    token = TokenHelper.for_user(users(:tom))

    put v1_me_url, params: {
      data: {
        display_name: 'new name',
        bio: 'sample bio thing'
      }
    }, headers: { Authorization: "Bearer " + token }, as: :json

    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal 'new name', body['display_name']
    assert_equal 'sample bio thing', body['bio']
  end
end
