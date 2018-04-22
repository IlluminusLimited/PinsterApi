# frozen_string_literal: true

require 'test_helper'

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collection = collections(:one)
  end

  test 'should get index' do
    get collections_url, as: :json
    assert_response :success
  end

  test 'should create collection' do
    assert_difference('Collection.count') do
      post collections_url, params: {
        collection: { description: @collection.description, name: @collection.name, user_id: @collection.user_id }
      }, as: :json
    end

    assert_response 201
  end

  test 'should show collection' do
    get collection_url(@collection), as: :json
    assert_response :success
  end

  test 'should update collection' do
    patch collection_url(@collection), params: {
      collection: { description: @collection.description, name: @collection.name, user_id: @collection.user_id }
    }, as: :json
    assert_response 200
  end

  test 'should destroy collection' do
    assert_difference('Collection.count', -1) do
      delete collection_url(@collection), as: :json
    end

    assert_response 204
  end
end
