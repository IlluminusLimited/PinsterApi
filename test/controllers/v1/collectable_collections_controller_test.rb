# frozen_string_literal: true

require 'test_helper'

class CollectableCollectionsControllerTest < ActionDispatch::IntegrationTest
  Bullet.add_whitelist type: :unused_eager_loading, class_name: "Collection", association: :collectable_collections
  Bullet.add_whitelist type: :unused_eager_loading, class_name: "CollectableCollection", association: :collectable

  setup do
    @collectable_collection = collectable_collections(:toms_keeper_2009_assortments)
  end

  test "collectable_collections are pagable" do
    token = TokenHelper.for_user(users(:tom))
    collection = collections(:toms_secret_collection)

    get v1_collection_collectable_collections_url(collection, page: { size: 1 }),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :success
    body = JSON.parse(response.body)
    get body['links']['next'], headers: { Authorization: "Bearer " + token }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal collectable_collections(:toms_secret_gargoyles_collectdables).id, body['data'].first['id']
  end

  test "non-owner cannot list collectable_collections for private collection" do
    token = TokenHelper.for_user(users(:sally))
    collection = collections(:toms_secret_collection)

    get v1_collection_collectable_collections_url(collection),
        headers: { Authorization: "Bearer " + token },
        as: :json
    assert_response :forbidden
  end

  test "non-owner cannot create collectable_collections for someone else" do
    token = TokenHelper.for_user(users(:sally))
    collection = collections(:toms_keepers_collection)

    post v1_collection_collectable_collections_url(collection),
         headers: { Authorization: "Bearer " + token },
         params: { data: { collectable_type: 'Pin',
                           collectable_id: pins(:texas_dragon).id,
                           collection_id: collection.id,
                           count: 4 } },
         as: :json
    assert_response :forbidden
  end

  test "should create collectable_collection" do
    token = TokenHelper.for_user(users(:tom))

    assert_difference('CollectableCollection.count') do
      post v1_collection_collectable_collections_url(@collectable_collection.collection_id),
           headers: { Authorization: "Bearer " + token },
           params: { data: { collectable_type: 'Pin',
                             collectable_id: pins(:texas_dragon).id,
                             count: 4 } },
           as: :json
      assert_response :created
    end
  end

  test "conflict when collectable_collection already exists" do
    token = TokenHelper.for_user(users(:sally))

    assert_no_difference('CollectableCollection.count') do
      post v1_collection_collectable_collections_url(collections(:sallys_favorite_collection)),
           headers: { Authorization: "Bearer " + token },
           params: { data: { collectable_type: 'Pin',
                             collectable_id: pins(:texas_dragon).id } },
           as: :json

      assert_response :unprocessable_entity
      assert_match "collection_id", response.body
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
    assert_response :ok
  end

  test "user cannot change others collectable_collections" do
    token = TokenHelper.for_user(users(:bob))

    patch v1_collectable_collection_url(@collectable_collection),
          headers: { Authorization: "Bearer " + token },
          params: { data: { count: 2 } },
          as: :json
    assert_response :forbidden
  end

  test "user cannot change collection_id" do
    token = TokenHelper.for_user(users(:tom))

    collection = collections(:sallys_favorite_collection)
    assert_no_difference(Collection.find(collection.id).collectable_collections.count.to_s) do
      patch v1_collectable_collection_url(@collectable_collection),
            headers: { Authorization: "Bearer " + token },
            params: { data: { collection_id: collection.id } },
            as: :json
      assert_response :ok
    end
  end

  test "should destroy collectable_collection" do
    token = TokenHelper.for_user(users(:bob), ['destroy:collectable_collection'])

    assert_difference('CollectableCollection.count', -1) do
      delete v1_collectable_collection_url(@collectable_collection),
             headers: { Authorization: "Bearer " + token },
             as: :json
      assert_response :no_content
    end
  end
end
