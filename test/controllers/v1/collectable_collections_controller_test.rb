# frozen_string_literal: true

require 'test_helper'

class CollectableCollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collectable_collection = collectable_collections(:one)
  end

  test 'should get index' do
    get v1_collectable_collections_url, as: :json
    assert_response :success
  end

  test 'should create collectable_collection' do
    assert_difference('CollectableCollection.count') do
      post v1_collectable_collections_url, params: {
        data: {
          collectable_id: @collectable_collection.collectable_id,
          collectable_type: @collectable_collection.collectable_type,
          collection_id: @collectable_collection.collection_id
        }
      }, as: :json
    end

    assert_response 201
  end

  test 'should show collectable_collection' do
    get v1_collectable_collection_url(@collectable_collection), as: :json
    assert_response :success
  end

  test 'should update collectable_collection' do
    patch v1_collectable_collection_url(@collectable_collection), params: {
      data: {
        collectable_id: @collectable_collection.collectable_id,
        collectable_type: @collectable_collection.collectable_type,
        collection_id: @collectable_collection.collection_id
      }
    }, as: :json
    assert_response 200
  end

  test 'should destroy collectable_collection' do
    assert_difference('CollectableCollection.count', -1) do
      delete v1_collectable_collection_url(@collectable_collection), as: :json
    end

    assert_response 204
  end
end
