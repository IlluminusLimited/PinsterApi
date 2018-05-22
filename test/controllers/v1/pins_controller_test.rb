# frozen_string_literal: true

require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pin = pins(:wisconsin_unicorn)
  end

  test "should get index" do
    get v1_pins_url, as: :json
    assert_response :success
  end

  test "moderator can create a pin" do
    token = authentications(:bob_token)

    assert_difference('Pin.count') do
      post v1_pins_url, headers: { Authorization: token.token },
                        params: {
                          data: {
                            name: @pin.name,
                            year: @pin.year,
                            description: @pin.description,
                            tags: @pin.tags
                          }
                        }, as: :json
    end

    assert_response 201
  end

  test "should show pin" do
    get v1_pin_url(@pin), as: :json
    assert_response :success
    assert_match v1_assortment_url(@pin.assortment, format: :json), response.body
  end

  test "moderator can update a pin" do
    token = authentications(:bob_token)

    patch v1_pin_url(@pin), headers: { Authorization: token.token },
                            params: {
                              data: {
                                description: @pin.description,
                                name: @pin.name,
                                year: @pin.year,
                                tags: @pin.tags
                              }
                            }, as: :json
    assert_response 200
  end

  test "moderator can destroy a pin" do
    token = authentications(:bob_token)

    assert_difference('Pin.count', -1) do
      delete v1_pin_url(@pin), headers: { Authorization: token.token }, as: :json
    end

    assert_response 204
  end

  test "should show pin with all images" do
    get v1_pin_url(@pin, all_images: true), as: :json
    assert_response :success

    @pin.all_images.each do |image|
      assert_match image.id, response.body
    end
  end
end
