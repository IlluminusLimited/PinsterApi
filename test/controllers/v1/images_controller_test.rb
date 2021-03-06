# frozen_string_literal: true

require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:texas_dragon_image_one)
  end

  test "Image service can create an image" do
    imageable = pins(:texas_dragon)
    token = incoming_image_service_jwt(imageable)

    assert_difference('Image.count', +1) do
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

  test "Image service can't create an image with the wrong token" do
    imageable = pins(:massachusetts_crab)
    token = incoming_image_service_jwt(imageable)

    assert_no_difference('Image.count') do
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
      assert_response :forbidden
    end
  end

  test "Users can get an image_service_token" do
    token = TokenHelper.for_user(users(:tom))
    collection = collections(:toms_keepers_collection)

    assert_no_difference('Image.count') do
      post v1_collection_images_url(collection),
           headers: { Authorization: "Bearer " + token }, as: :json
      assert_response :accepted
      body = JSON.parse(response.body)
      assert body['image_service_token']
      assert body['image_service_url']
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

  test "Tom cannot update others collection image" do
    token = TokenHelper.for_user(users(:tom))
    image = images(:sallys_favorite_collection_main_image)
    patch v1_image_url(image), headers: { Authorization: "Bearer " + token },
                               params: {
                                 data: {
                                   featured: Time.now.in_time_zone,
                                   name: "Cool image",
                                   description: "This is a really cool image"
                                 }
                               }, as: :json
    assert_response :forbidden
  end

  test "Tom cannot update restricted fields on an image" do
    token = TokenHelper.for_user(users(:tom))
    image = images(:toms_face)
    patch v1_image_url(image), headers: { Authorization: "Bearer " + token },
                               params: {
                                 data: {
                                   imageable: nil,
                                   base_file_name: 'asdf',
                                   storage_location_uri: nil
                                 }
                               }, as: :json
    assert_response :ok
    assert_not_equal 'asdf', Image.find(image.id).base_file_name
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

  test "Tom can destroy their own image" do
    token = TokenHelper.for_user(users(:tom))

    assert_difference('Image.count', -1) do
      delete v1_image_url(images(:toms_face)), headers: { Authorization: "Bearer " + token }, as: :json
      assert_response 204
    end
  end
end
