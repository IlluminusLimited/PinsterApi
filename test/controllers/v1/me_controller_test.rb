# frozen_string_literal: true

require 'test_helper'

class MeControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    tom_token = authentications(:tom_token)
    get v1_me_url, headers: { Authorization: tom_token.token }, as: :json

    assert_response :success
  end

  test "should get update" do
    tom_token = authentications(:tom_token)
    put v1_me_url, params: {
      data: {
        display_name: 'new name',
        bio: 'sample bio thing',
        email: 'new-email@me.no'
      }
    }, headers: { Authorization: tom_token.token }, as: :json

    assert_response :success
  end
end
