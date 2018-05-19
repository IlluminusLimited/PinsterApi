# frozen_string_literal: true

require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:texas_dragon_image_one)
  end

  test "admin can create an image" do
    token = authentications(:andrew_token)

    assert_difference('Image.count') do
      post v1_images_url, headers: { Authorization: token.token },
                          params: {
                            data: {
                              imageable_id: @image.imageable_id,
                              imageable_type: @image.imageable_type,
                              base_file_name: @image.base_file_name,
                              storage_location_uri: @image.storage_location_uri,
                              featured: @image.featured,
                              name: @image.name,
                              description: @image.description
                            }
                          }, as: :json
    end

    assert_response 201
  end

  test "should show image" do
    get v1_image_url(@image), as: :json
    assert_response :success
  end

  test "moderator can update an image" do
    token = authentications(:bob_token)

    patch v1_image_url(@image), headers: { Authorization: token.token },
                                params: {
                                  data: {
                                    imageable: @image.imageable,
                                    base_file_name: @image.base_file_name,
                                    storage_location_uri: @image.storage_location_uri
                                  }
                                }, as: :json
    assert_response 200
  end

  test "moderator can destroy an image" do
    token = authentications(:bob_token)

    assert_difference('Image.count', -1) do
      delete v1_image_url(@image), headers: { Authorization: token.token }, as: :json
    end

    assert_response 204
  end
end
