# frozen_string_literal: true

require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pin = pins(:wisconsin_unicorn)
  end

  test "index does not contain unpublished" do
    get v1_pins_url, as: :json
    assert_response :success
    id = pins(:ohio_cow).id
    assert_no_match id, response.body
  end

  test "anon cannot create a pin" do
    assert_difference('Pin.count', 0) do
      post v1_pins_url,
           params: {
             data: {
               name: @pin.name,
               year: @pin.year,
               description: @pin.description,
               tags: @pin.tags
             }
           }, as: :json
      assert_response :unauthorized
    end
  end

  test "Tom cannot create a pin" do
    token = TokenHelper.for_user(users(:tom))

    assert_difference('Pin.count', 0) do
      post v1_pins_url, headers: { Authorization: "Bearer " + token },
                        params: {
                          data: {
                            name: @pin.name,
                            year: @pin.year,
                            description: @pin.description,
                            tags: @pin.tags
                          }
                        }, as: :json
      assert_response :forbidden
    end
  end

  test "moderator can create a pin" do
    token = TokenHelper.for_user(users(:bob), %w[create:pin])

    assert_difference('Pin.count') do
      post v1_pins_url, headers: { Authorization: "Bearer " + token },
                        params: {
                          data: {
                            name: @pin.name,
                            year: @pin.year,
                            description: @pin.description,
                            tags: @pin.tags
                          }
                        }, as: :json
      assert_response :created
    end
  end

  test "should show pin" do
    get v1_pin_url(@pin), as: :json
    assert_response :success
    assert_match v1_assortment_url(@pin.assortment, format: :json), response.body
  end

  test "moderator can update a pin" do
    token = TokenHelper.for_user(users(:bob), %w[update:pin])

    patch v1_pin_url(@pin), headers: { Authorization: "Bearer " + token },
                            params: {
                              data: {
                                description: @pin.description,
                                name: @pin.name,
                                year: @pin.year,
                                tags: @pin.tags
                              }
                            }, as: :json
    assert_response :ok
  end

  test "moderator can destroy a pin" do
    token = TokenHelper.for_user(users(:bob), %w[destroy:pin])

    assert_difference('Pin.count', -1) do
      delete v1_pin_url(@pin), headers: { Authorization: "Bearer " + token }, as: :json
      assert_response :no_content
    end
  end

  test "moderator can publish a pin" do
    token = TokenHelper.for_user(users(:bob), %w[update:pin publish:pin])
    pin = Pin.create!(name: 'bob')
    puts pin
    assert_difference('Pin.published.count', +1) do
      patch v1_pin_url(pin), headers: { Authorization: "Bearer " + token },
                             params: {
                               data: {
                                 published: true
                               }
                             },
                             as: :json
      assert_response :ok
    end
  end

  test "should show pin with all images" do
    get v1_pin_url(@pin, all_images: true), as: :json
    assert_response :success

    @pin.all_images.each do |image|
      assert_match image.id, response.body
    end
  end

  test "should show pin with user's collectable_collections" do
    token = TokenHelper.for_user(users(:tom))

    get v1_pin_url(@pin, with_collectable_collections: true),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :success

    @pin.collectable_collections.each do |collection|
      assert_match collection.id, response.body
    end
  end

  test "should show pin without collectable_collections" do
    get v1_pin_url(@pin, with_collectable_collections: true),
        as: :json
    assert_response :success

    @pin.collectable_collections.each do |collection|
      assert_no_match collection.id, response.body
    end
  end
end
