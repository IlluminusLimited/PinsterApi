# frozen_string_literal: true

require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = collections(:toms_keepers_collection)
  end

  test "anon can get only users public collections" do
    tom = users(:tom)
    get v1_user_collections_url(user_id: tom.id),
        as: :json
    assert_response :success
    assert_not response.body.blank?
    tom.collections.where(public: true).pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "user can get all of their collections summaries" do
    tom = users(:tom)

    token = TokenHelper.for_user(tom)
    get v1_user_collections_summary_url(user_id: tom.id),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :success
    assert_not response.body.blank?
    tom.collections.pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "user can get all of their collections" do
    tom = users(:tom)

    token = TokenHelper.for_user(tom)
    get v1_user_collections_url(user_id: tom.id),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :success
    assert_not response.body.blank?
    tom.collections.pluck(:name).each do |collection_name|
      assert_match collection_name, response.body
    end
  end

  test "user can get other userss public collections" do
    tom = users(:tom)
    sally = users(:sally)

    token = TokenHelper.for_user(tom)
    get v1_user_collections_url(user_id: sally.id),
        headers: { Authorization: "Bearer " + token },
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
    tom = users(:tom)

    token = TokenHelper.for_user(tom)
    assert_difference('Collection.count') do
      post v1_user_collections_url(user_id: tom.id),
           headers: { Authorization: "Bearer " + token },
           params: {
             data: {
               description: @collection.description,
               name: @collection.name
             }
           }, as: :json
      assert_response :created
    end
  end

  test "Tom can update a collection" do
    tom = users(:tom)

    token = TokenHelper.for_user(tom)
    patch v1_collection_url(@collection), headers: { Authorization: "Bearer " + token },
                                          params: {
                                            data: {
                                              description: @collection.description,
                                              name: @collection.name
                                            }
                                          }, as: :json
    assert_response :ok
  end

  test "Tom can destroy a collection" do
    tom = users(:tom)

    token = TokenHelper.for_user(tom)

    assert_difference('Collection.count', -1) do
      delete v1_collection_url(@collection), headers: { Authorization: "Bearer " + token }, as: :json
      assert_response :no_content
    end
  end

  test "Bob cannot destroy another users collection" do
    token = TokenHelper.for_user(users(:bob))

    assert_difference('Collection.count', 0) do
      delete v1_collection_url(@collection), headers: { Authorization: "Bearer " + token }, as: :json
      assert_response :forbidden
    end
  end

  test "Andrew can do whatever the hell he wants" do
    token = TokenHelper.for_user(users(:andrew), ['destroy:collection'])

    assert_difference('Collection.count', -1) do
      delete v1_collection_url(@collection), headers: { Authorization: "Bearer " + token }, as: :json
      assert_response :no_content
    end
  end
end
