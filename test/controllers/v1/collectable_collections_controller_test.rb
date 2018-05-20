# frozen_string_literal: true

require 'test_helper'

class V1::CollectableCollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @v1_collectable_collection = v1_collectable_collections(:one)
  end

  test "should get index" do
    get v1_collectable_collections_url, as: :json
    assert_response :success
  end

  test "should create v1_collectable_collection" do
    assert_difference('V1::CollectableCollection.count') do
      post v1_collectable_collections_url, params: { v1_collectable_collection: {} }, as: :json
    end

    assert_response 201
  end

  test "should show v1_collectable_collection" do
    get v1_collectable_collection_url(@v1_collectable_collection), as: :json
    assert_response :success
  end

  test "should update v1_collectable_collection" do
    patch v1_collectable_collection_url(@v1_collectable_collection), params: { v1_collectable_collection: {} }, as: :json
    assert_response 200
  end

  test "should destroy v1_collectable_collection" do
    assert_difference('V1::CollectableCollection.count', -1) do
      delete v1_collectable_collection_url(@v1_collectable_collection), as: :json
    end

    assert_response 204
  end
end
