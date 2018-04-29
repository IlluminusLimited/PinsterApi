# frozen_string_literal: true

require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = collections(:toms_keepers_collection)
  end

  test "should get user collections index" do
    get v1_user_collections_url(user_id: @collection.user), as: :json
    assert_response :success
  end

  test "should show collection" do
    get v1_collection_url(@collection), as: :json
    assert_response :success
  end

  test "Tom can create a collection" do
    tom_token = authentications(:tom_token)
    assert_difference('Collection.count') do
      post v1_user_collections_url(user_id: @collection.user_id),
           headers: { Authorization: tom_token.token },
           params: {
             data: {
               description: @collection.description,
               name: @collection.name,
               user_id: @collection.user_id
             }
           }, as: :json
    end

    assert_response 201
  end

  test "Tom can update a collection" do
    tom_token = authentications(:tom_token)

    patch v1_collection_url(@collection), headers: { Authorization: tom_token.token },
                                          params: {
                                            data: {
                                              description: @collection.description,
                                              name: @collection.name
                                            }
                                          }, as: :json
    assert_response 200
  end

  test "Tom can destroy a collection" do
    tom_token = authentications(:tom_token)

    assert_difference('Collection.count', -1) do
      delete v1_collection_url(@collection), headers: { Authorization: tom_token.token }, as: :json
    end

    assert_response 204
  end
end
