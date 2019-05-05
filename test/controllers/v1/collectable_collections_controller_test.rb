# frozen_string_literal: true

require 'test_helper'

class CollectableCollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collectable_collection = collectable_collections(:two)
  end

  test "should get collection's collectable_collections index" do
    token = TokenHelper.for_user(users(:tom))

    get v1_collection_collectable_collections_url(@collectable_collection.collection_id),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :success
  end

  test "should create collectable_collection" do
    token = TokenHelper.for_user(users(:tom))

    assert_difference('CollectableCollection.count') do
      post v1_collection_collectable_collections_url(@collectable_collection.collection_id),
           headers: { Authorization: "Bearer " + token },
           params: { data: { collectable_type: 'Pin',
                             collectable_id: pins(:texas_dragon).id,
                             collection_id: collections(:toms_keepers_collection).id,
                             count: 4 } },
           as: :json
      assert_response 201
    end
  end

  test "should show collectable_collection" do
    token = TokenHelper.for_user(users(:tom))

    get v1_collectable_collection_url(@collectable_collection),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :success
  end

  test "should update collectable_collection" do
    token = TokenHelper.for_user(users(:bob), ['update:collectable_collection'])

    patch v1_collectable_collection_url(@collectable_collection),
          headers: { Authorization: "Bearer " + token },
          params: { data: { count: 2 } },
          as: :json
    assert_response 200
  end

  test "should destroy collectable_collection" do
    token = TokenHelper.for_user(users(:bob), ['destroy:collectable_collection'])

    assert_difference('CollectableCollection.count', -1) do
      delete v1_collectable_collection_url(@collectable_collection),
             headers: { Authorization: "Bearer " + token },
             as: :json
      assert_response 204
    end
  end
end
