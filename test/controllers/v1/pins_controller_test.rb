# frozen_string_literal: true

require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pin = pins(:texas_dragon)
  end

  test "should get index" do
    get v1_pins_url, as: :json
    assert_response :success
  end

  test "Tom can create a pin" do
    tom_token = authentications(:tom_token)

    assert_difference('Pin.count') do
      post v1_pins_url, headers: { Authorization: tom_token.token },
                        params: {
                          data: {
                            name: @pin.name,
                            year: @pin.year,
                            description: @pin.description
                          }
                        }, as: :json
    end

    assert_response 201
  end

  test "should show pin" do
    get v1_pin_url(@pin), as: :json
    assert_response :success
  end

  test "Tom can update a pin" do
    tom_token = authentications(:tom_token)

    patch v1_pin_url(@pin), headers: { Authorization: tom_token.token },
                            params: {
                              data: {
                                description: @pin.description,
                                name: @pin.name,
                                year: @pin.year
                              }
                            }, as: :json
    assert_response 200
  end

  test "Tom can destroy a pin" do
    tom_token = authentications(:tom_token)

    assert_difference('Pin.count', -1) do
      delete v1_pin_url(@pin), headers: { Authorization: tom_token.token }, as: :json
    end

    assert_response 204
  end
end
