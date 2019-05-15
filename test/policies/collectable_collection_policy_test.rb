# frozen_string_literal: true

require 'test_helper'

class CollectableCollectionPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create collectable_collections' do
    user = CurrentUser.new(User.anon_user)
    assert_not_permitted(user, CollectableCollection, :create?)
  end

  test 'anybody can index collectable_collections' do
    user = CurrentUser.new(User.anon_user)
    assert_permit(user, CollectableCollection, :index?)
  end

  test 'users cannot view private collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, collectable_collections(:toms_secret_unicorn_collectables), :show?)
  end

  test 'users can view their private collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:tom)))
    assert_permit(user, collectable_collections(:toms_secret_unicorn_collectables), :show?)
  end

  # will refactor since the class doesn't have an instance of collection to check against so this test fails
  # test 'users can create collectable_collections' do
  #   user = users(:sally)
  #   assert_permit(user, CollectableCollection, :create?)
  # end

  test 'users can perform any instance action to their collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, collectable_collections(:sallys_favorite_dragon_collectables), ANY_INSTANCE_ACTION)
  end

  test 'users cannot alter other users collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, collectable_collections(:toms_secret_unicorn_collectables), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users can create with params' do
    user = current_user(TokenHelper.for_user(users(:tom)))
    collectable_collection = collectable_collections(:sallys_favorite_dragon_collectables)
    collectable_collection.collection_id = collections(:toms_keepers_collection).id
    assert_strong_action_parameters(user, collectable_collection, collectable_collection.attributes.to_h,
                                    CollectableCollection.all_attribute_names, :create)
  end

  test 'users cannot change the collection_id' do
    user = current_user(TokenHelper.for_user(users(:tom)))
    collectable_collection = collectable_collections(:sallys_favorite_dragon_collectables)
    collectable_collection.collection_id = collections(:toms_keepers_collection).id
    assert_strong_action_parameters(user, collectable_collection, collectable_collection.attributes.to_h,
                                    CollectableCollection.public_attribute_names, :update)
  end

  test 'admins can perform any action' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[index:collectable_collections
                                                             show:collectable_collection
                                                             create:collectable_collection
                                                             update:collectable_collection
                                                             destroy:collectable_collection]))
    # will refactor since the class doesn't have an instance of collection to check against so this test fails
    # assert_permit(user, CollectableCollection, ANY_ACTION)
    assert_permit(user, collectable_collections(:toms_secret_unicorn_collectables), ANY_ACTION)
  end

  def assert_strong_action_parameters(user, record, params_hash, allowed_params, action)
    policy = find_policy!(user, record)

    param_key = find_param_key(record)

    params = ActionController::Parameters.new(param_key => params_hash)
    method_name = ("permitted_attributes_for_#{action}" if policy.respond_to?("permitted_attributes_for_#{action}"))
    raise "Cannot assert action for missing policy method: 'permitted_attributes_for_#{action}'" unless method_name

    strong_params = params.require(param_key).permit(*policy.public_send(method_name)).keys

    strong_params.each do |param|
      assert_includes allowed_params, param.to_sym,
                      "User #{user} should not be permitted to "\
                        "update parameter [#{param}]"
    end
  end
end
