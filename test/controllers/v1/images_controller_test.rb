# frozen_string_literal: true

require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:texas_dragon_image_one)
  end

  test "Bob can create an image" do
    token = TokenHelper.for_user(users(:bob), %w[create:image])

    assert_difference('Image.count') do
      post v1_images_url,
           headers: { Authorization: "Bearer " + token },
           params: {
             data: {
               imageable_id: @image.imageable_id,
               imageable_type: @image.imageable_type,
               base_file_name: @image.base_file_name,
               storage_location_uri: @image.storage_location_uri,
               featured: @image.featured,
               name: @image.name,
               description: @image.description,
               thumbnailable: @image.thumbnailable
             }
           }, as: :json
      assert_response :created
    end
  end

  test "An image on a collection can be created" do
    token = TokenHelper.for_user(users(:tom))
    collection = collections(:toms_keepers_collection)

    assert_difference('Image.count', +1) do
      post v1_collection_images_url(collection),
           headers: { Authorization: "Bearer " + token },
           params: {
             data: {
               encoded: @image.encoded,
               featured: @image.featured,
               name: @image.name,
               description: @image.description
             }
           }, as: :json
      assert_response :accepted
    end
  end

  test "should show imageables images" do
    get polymorphic_url([:v1, @image.imageable, :images]), as: :json
    assert_response :success
    assert_match @image.storage_location_uri, response.body
  end

  test "should show image" do
    get v1_image_url(@image), as: :json
    assert_response :success
    non_date_attributes = @image.attributes.reject do |key|
      %i[created_at updated_at featured].include?(key.to_sym)
    end
    non_date_attributes.values.each do |value|
      assert_match(value.to_s, response.body)
    end
  end

  test "Tom can update his profile picture" do
    token = TokenHelper.for_user(users(:tom))
    image = images(:toms_face)
    patch v1_image_url(image), headers: { Authorization: "Bearer " + token },
                               params: {
                                 data: {
                                   featured: Time.now.in_time_zone,
                                   name: "Cool image",
                                   description: "This is a really cool image"
                                 }
                               }, as: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert_not_nil body['featured']
    assert_equal "Cool image", body['name']
    assert_equal "This is a really cool image", body['description']
  end

  test "Bob cannot update restricted fields on an image" do
    token = TokenHelper.for_user(users(:bob))

    patch v1_image_url(@image), headers: { Authorization: "Bearer " + token },
                                params: {
                                  data: {
                                    imageable: @image.imageable,
                                    base_file_name: @image.base_file_name,
                                    storage_location_uri: @image.storage_location_uri
                                  }
                                }, as: :json
    assert_response :forbidden
  end

  test "anon cannot destroy an image" do
    assert_difference('Image.count', 0) do
      delete v1_image_url(@image), as: :json
      assert_response :forbidden
    end
  end

  test "Bob can destroy an image" do
    token = TokenHelper.for_user(users(:bob), %w[destroy:image])

    assert_difference('Image.count', -1) do
      delete v1_image_url(@image), headers: { Authorization: "Bearer " + token }, as: :json
      assert_response 204
    end
  end

  # Not supported until more work is done on images
  # test "Tom can update his own image" do
  #   token = TokenHelper.for_user(users(:tom))
  #   image = images(:toms_face)
  #
  #   patch v1_image_url(image), headers: { Authorization: "Bearer " + token },
  #         params: {
  #             data: {
  #                 name: "cool name",
  #                 description: "cool description"
  #             }
  #         }, as: :json
  #   assert_response 200
  # end
  #
  # test "Tom can destroy their own image" do
  #   token = TokenHelper.for_user(users(:tom))
  #
  #   assert_difference('Image.count', -1) do
  #     delete v1_image_url(images(:toms_face)), headers: { Authorization: "Bearer " + token }, as: :json
  #     assert_response 204
  #   end
  # end
end
