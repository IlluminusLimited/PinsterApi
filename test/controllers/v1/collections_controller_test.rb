# frozen_string_literal: true

require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = collections(:toms_keepers_collection)
  end

  test "anon can get only user's public collections" do
    tom_token = authentications(:tom_token)
    get v1_user_collections_url(user_id: tom_token.user.id),
        as: :json
    assert_response :success
    assert_not response.body.blank?
    tom_token.user.collections.where(public: true).pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "user can get all of their collections summaries" do
    tom_token = authentications(:tom_token)
    get v1_user_collections_summary_url(user_id: tom_token.user.id),
        headers: { Authorization: tom_token.token },
        as: :json
    assert_response :success
    assert_not response.body.blank?
    tom_token.user.collections.pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "user can get all of their collections" do
    tom_token = authentications(:tom_token)
    get v1_user_collections_url(user_id: tom_token.user.id),
        headers: { Authorization: tom_token.token },
        as: :json
    assert_response :success
    assert_not response.body.blank?
    tom_token.user.collections.pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "user can get other users's public collections" do
    tom_token = authentications(:tom_token)
    sally = users(:sally)
    get v1_user_collections_url(user_id: sally.id),
        headers: { Authorization: tom_token.token },
        as: :json

    assert_response :success
    assert_not response.body.blank?
    sally.collections.pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "should show collection" do
    get v1_collection_url(@collection), as: :json
    assert_response :success
    assert_match @collection.collectable_count.to_s, response.body
  end

  test "Tom can create a collection" do
    tom_token = authentications(:tom_token)
    assert_difference('Collection.count') do
      post v1_user_collections_url(user_id: tom_token.user.id),
           headers: { Authorization: tom_token.token },
           params: {
             data: {
               description: @collection.description,
               name: @collection.name
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
