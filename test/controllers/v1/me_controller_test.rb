# frozen_string_literal: true

require 'test_helper'

class MeControllerTest < ActionDispatch::IntegrationTest
  test "Sally's token returns unauthorized" do
    token = authentications(:sally_token)
    get v1_me_url, headers: { Authorization: token.token }

    assert_response :unauthorized
  end

  test "should show me" do
    token = authentications(:tom_token)
    get v1_me_url, headers: { Authorization: token.token }, as: :json

    assert_response :success
  end

  test "should update me" do
    token = authentications(:tom_token)
    put v1_me_url, params: {
      data: {
        display_name: 'new name',
        bio: 'sample bio thing',
        email: 'new-email@me.no'
      }
    }, headers: { Authorization: token.token }, as: :json

    assert_response :success
  end
end
