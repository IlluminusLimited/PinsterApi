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

  test "Bob can create an assortment" do
    token = authentications(:bob_token)

    assert_difference('Assortment.count') do
      post v1_assortments_url, headers: { Authorization: token.token },
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

  test "Bob can update an assortment" do
    token = authentications(:bob_token)

    patch v1_assortment_url(@assortment), headers: { Authorization: token.token },
                                          params: {
                                            data: {
                                              description: @assortment.description,
                                              id: @assortment.id,
                                              name: @assortment.name
                                            }
                                          }, as: :json
    assert_response 200
  end

  test "Bob can destroy an assortment" do
    token = authentications(:bob_token)
    assert @assortment.valid?
    @assortment = Assortment.find(@assortment.id)
    assert @assortment.valid?
    assert_difference('Assortment.count', -1) do
      delete v1_assortment_url(@assortment),  headers: { Authorization: token.token }, as: :json
    end

    assert_response 204
  end
end
