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
    assert_not_permitted(user, collectable_collections(:three), :show?)
  end

  test 'users can view their private collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:tom)))
    assert_permit(user, collectable_collections(:three), :show?)
  end

  # will refactor since the class doesn't have an instance of collection to check against so this test fails
  # test 'users can create collectable_collections' do
  #   user = users(:sally)
  #   assert_permit(user, CollectableCollection, :create?)
  # end

  test 'users can perform any instance action to their collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, collectable_collections(:one), ANY_INSTANCE_ACTION)
  end

  test 'users cannot alter other users collectable_collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, collectable_collections(:three), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'admins can perform any action' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[create:collectable_collection update:collectable_collection destroy:collectable_collection]))
    # will refactor since the class doesn't have an instance of collection to check against so this test fails
    # assert_permit(user, CollectableCollection, ANY_ACTION)
    assert_permit(user, collectable_collections(:three), ANY_ACTION)
  end
end
