# frozen_string_literal: true

require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:texas_dragon_image_one)
  end

  test 'should get index' do
    get v1_images_url, as: :json
    assert_response :success
  end

  test 'should create image' do
    assert_difference('Image.count') do
      post v1_images_url, params: {
        data: {
          description: @image.description,
          featured: @image.featured,
          imageable_id: @image.imageable_id,
          imageable_type: @image.imageable_type,
          name: @image.name,
          base_file_name: @image.base_file_name,
          storage_location_uri: @image.storage_location_uri
        }
      }, as: :json
    end

    assert_response 201
  end

  test 'should show image' do
    get v1_image_url(@image), as: :json
    assert_response :success
  end

  test 'should update image' do
    patch v1_image_url(@image), params: {
      data: {
        description: @image.description,
        featured: @image.featured,
        imageable_id: @image.imageable_id,
        imageable_type: @image.imageable_type,
        name: @image.name,
        base_file_name: @image.base_file_name,
        storage_location_uri: @image.storage_location_uri
      }
    }, as: :json
    assert_response 200
  end

  test 'should destroy image' do
    assert_difference('Image.count', -1) do
      delete v1_image_url(@image), as: :json
    end

    assert_response 204
  end
end
