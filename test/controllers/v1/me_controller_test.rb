# frozen_string_literal: true

require 'test_helper'

class MeControllerTest < ActionDispatch::IntegrationTest
  test "Sally's token returns unauthorized" do
    token = authentications(:sally_token)
    get v1_me_url, headers: { Authorization: token.token }

    assert_response :unauthorized
  end

  test "should show me" do
    authentication = authentications(:tom_token)
    get v1_me_url, headers: { Authorization: authentication.token }, as: :json

    assert_response :success
    assert_not response.body.blank?
    body = JSON.parse(response.body)
    assert_equal authentication.user.display_name, body['display_name']
    assert_equal authentication.user.role, body['role']
    assert_equal authentication.user.bio, body['bio']
  end

  test "user cannot update role" do
    token = authentications(:tom_token)
    put v1_me_url, params: {
      data: {
        display_name: 'new name',
        bio: 'sample bio thing',
        role: 1
      }
    }, headers: { Authorization: token.token }, as: :json

    assert_response :success
    assert_not response.body.blank?
    body = JSON.parse(response.body)
    assert_equal 'new name', body['display_name']
  end

  test "should update me" do
    token = authentications(:tom_token)
    put v1_me_url, params: {
      data: {
        display_name: 'new name',
        bio: 'sample bio thing',
      }
    }, headers: { Authorization: token.token }, as: :json

    assert_response :success
  end
end
