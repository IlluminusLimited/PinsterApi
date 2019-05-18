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

  test "anon cannnot create an assortment" do
    assert_difference('Assortment.count', 0) do
      post v1_assortments_url,
           params: {
             data: {
               description: @assortment.description,
               id: @assortment.id,
               name: @assortment.name,
               tags: { tom: 'asdf' }
             }
           }, as: :json
      assert_response :unauthorized
    end
  end

  test "Tom cannnot create an assortment" do
    token = TokenHelper.for_user(users(:tom))

    assert_difference('Assortment.count', 0) do
      post v1_assortments_url, headers: { Authorization: "Bearer " + token },
                               params: {
                                 data: {
                                   description: @assortment.description,
                                   id: @assortment.id,
                                   name: @assortment.name,
                                   tags: { tom: 'asdf' }
                                 }
                               }, as: :json
      assert_response :forbidden
    end
  end

  test "Bob can create an assortment" do
    token = TokenHelper.for_user(users(:bob), %w[create:assortment])

    assert_difference('Assortment.count') do
      post v1_assortments_url, headers: { Authorization: "Bearer " + token },
                               params: {
                                 data: {
                                   description: @assortment.description,
                                   id: @assortment.id,
                                   name: @assortment.name,
                                   tags: { bob: 'bllago' }
                                 }
                               }, as: :json
      assert_response 201
    end
  end

  test "anon cannot update an assortment" do
    patch v1_assortment_url(@assortment),
          params: {
            data: {
              description: @assortment.description,
              id: @assortment.id,
              name: @assortment.name
            }
          }, as: :json
    assert_response :unauthorized
  end

  test "Tom cannot update an assortment" do
    token = TokenHelper.for_user(users(:tom))

    patch v1_assortment_url(@assortment), headers: { Authorization: "Bearer " + token },
                                          params: {
                                            data: {
                                              description: @assortment.description,
                                              id: @assortment.id,
                                              name: @assortment.name
                                            }
                                          }, as: :json
    assert_response :forbidden
  end

  test "Bob can update an assortment" do
    token = TokenHelper.for_user(users(:bob), %w[update:assortment])

    patch v1_assortment_url(@assortment), headers: { Authorization: "Bearer " + token },
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
    token = TokenHelper.for_user(users(:bob), %w[destroy:assortment])
    assert @assortment.valid?
    @assortment = Assortment.find(@assortment.id)
    assert @assortment.valid?

    assert_difference('Assortment.count', -1) do
      delete v1_assortment_url(@assortment),  headers: { Authorization: "Bearer " + token }, as: :json
      assert_response 204
    end
  end

  test "should show assortment with user's collectable_collections" do
    token = TokenHelper.for_user(users(:tom))

    get v1_assortment_url(@assortment, with_collectable_collections: true),
        headers: { Authorization: "Bearer " + token },
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
