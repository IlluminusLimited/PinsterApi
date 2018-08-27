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
                                   name: @assortment.name,
                                   tags: { bob: 'bllago' }
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

  test "should show assortment with user's collectable_collections" do
    authentication = authentications(:tom_token)

    get v1_assortment_url(@assortment, with_collectable_collections: true),
        headers: { Authorization: authentication.token },
        as: :json
    assert_response :success

    @assortment.collectable_collections.each do |collection|
      assert_match collection.id, response.body
    end
  end

  test "should show assortment without collectable_collections" do
    get v1_assortment_url(@assortment, with_collectable_collections: true),
        as: :json
    assert_response :success

    @assortment.collectable_collections.each do |collection|
      assert_no_match collection.id, response.body
    end
  end
end
