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
    body = JSON.parse(response.body)

    assert_equal "Signature has expired", body['message']
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
    # assert_equal tom.images.first.storage_location_uri, body['images'][0]['storage_location_uri']
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

  test "apipie errors are rescued" do
    token = TokenHelper.for_user(users(:tom))

    patch v1_me_url, params: {
      data: {
        display_name: 'new name',
        bio: nil
      }
    }, headers: { Authorization: "Bearer " + token }, as: :json

    assert_response :unprocessable_entity
    assert_match 'Must be a String', response.body
  end

  test "user cannot change external_user_id" do
    tom = users(:tom)
    token = TokenHelper.for_user(tom)

    put v1_me_url, params: {
      data: {
        external_user_id: 'new id'
      }
    }, headers: { Authorization: "Bearer " + token }, as: :json

    assert_response :ok
    assert_equal tom.external_user_id, User.find_by(display_name: 'tom').external_user_id
  end

  test "Unknown user is not authorized" do
    sub = 'facebook|12341234'
    token = TokenHelper.generate_jwt(sub, [], (Time.now.in_time_zone + 20.minutes).to_i)

    get v1_me_url, headers: { Authorization: "Bearer " + token }, as: :json

    assert_response :unauthorized
  end
end
