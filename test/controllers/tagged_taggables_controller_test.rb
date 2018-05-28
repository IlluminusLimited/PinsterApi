require 'test_helper'

class TaggedTaggablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tagged_taggable = tagged_taggables(:one)
  end

  test "should get index" do
    get tagged_taggables_url, as: :json
    assert_response :success
  end

  test "should create tagged_taggable" do
    assert_difference('TaggedTaggable.count') do
      post tagged_taggables_url, params: { tagged_taggable: { tag_id: @tagged_taggable.tag_id, taggable_id: @tagged_taggable.taggable_id, taggable_type: @tagged_taggable.taggable_type } }, as: :json
    end

    assert_response 201
  end

  test "should show tagged_taggable" do
    get tagged_taggable_url(@tagged_taggable), as: :json
    assert_response :success
  end

  test "should update tagged_taggable" do
    patch tagged_taggable_url(@tagged_taggable), params: { tagged_taggable: { tag_id: @tagged_taggable.tag_id, taggable_id: @tagged_taggable.taggable_id, taggable_type: @tagged_taggable.taggable_type } }, as: :json
    assert_response 200
  end

  test "should destroy tagged_taggable" do
    assert_difference('TaggedTaggable.count', -1) do
      delete tagged_taggable_url(@tagged_taggable), as: :json
    end

    assert_response 204
  end
end
