# frozen_string_literal: true

require 'test_helper'

class AssortmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assortment = assortments(:wisconsin_2009)
  end

  test "should get index" do
    get v1_assortments_url, as: :json
    assert_response :success
  end

  test "should show assortment" do
    get v1_assortment_url(@assortment), as: :json
    assert_response :success
  end

  test "Tom can create an assortment" do
    tom_token = authentications(:tom_token)

    assert_difference('Assortment.count') do
      post v1_assortments_url, headers: { Authorization: tom_token.token },
                               params: {
                                 data: {
                                   description: @assortment.description,
                                   id: @assortment.id,
                                   name: @assortment.name
                                 }
                               }, as: :json
    end

    assert_response 201
  end

  test "Tom can update an assortment" do
    tom_token = authentications(:tom_token)

    patch v1_assortment_url(@assortment), headers: { Authorization: tom_token.token },
                                          params: {
                                            data: {
                                              description: @assortment.description,
                                              id: @assortment.id,
                                              name: @assortment.name
                                            }
                                          }, as: :json
    assert_response 200
  end

  test "Tom can destroy an assortment" do
    tom_token = authentications(:tom_token)

    assert_difference('Assortment.count', -1) do
      delete v1_assortment_url(@assortment),  headers: { Authorization: tom_token.token }, as: :json
    end

    assert_response 204
  end
end
