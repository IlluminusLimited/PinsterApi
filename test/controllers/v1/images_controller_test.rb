# frozen_string_literal: true

require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:texas_dragon_image_one)
  end

  test "should get show" do
    get v1_image_url(images(:texas_dragon_image_one))
    assert_response :success
  end
  #
  # test "should get create" do
  #   token = authentications(:bob_token)
  #   assert_difference('Image.count') do
  #     post v1_user_images_url(user_id: token.user.id),
  #          headers: { Authorization: token.token },
  #          params: {
  #            data: {
  #              description: @image.description,
  #              name: @image.name
  #            }
  #          }, as: :json
  #   end
  #
  #   assert_response 201
  # end

  test "should get update" do
    patch v1_image_url(@image)
    assert_response :success
  end

  test "should get destroy" do
    delete v1_image_url(@image)
    assert_response :success
  end
end
