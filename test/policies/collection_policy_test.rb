# frozen_string_literal: true

require 'test_helper'

class CollectionPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create collections' do
    user = CurrentUser.new(User.anon_user)
    assert_not_permitted(user, Collection, :create?)
  end

  test 'anybody can index collections' do
    user = CurrentUser.new(User.anon_user)
    assert_permit(user, Collection, :index?)
  end

  test 'users cannot view private collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, collections(:toms_secret_collection), :show?)
  end

  test 'users can view their private collections' do
    user = current_user(TokenHelper.for_user(users(:tom)))
    assert_permit(user, collections(:toms_secret_collection), :show?)
  end

  test 'users can create collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, Collection, :create?)
  end

  test 'users can perform any instance action to their collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, collections(:sallys_favorite_collection), ANY_INSTANCE_ACTION)
  end

  test 'users cannot alter other users collections' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, collections(:toms_keepers_collection), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'user cannot change the user_id' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    collection = collections(:sallys_favorite_collection)
    collection.user_id = users(:tom).id
    assert_strong_parameters(user, collection, collection.attributes.to_h,
                             Collection.public_attribute_names)
  end

  test 'admin can change the user_id' do
    user = current_user(TokenHelper.for_user(users(:andrew), %w[update:collection]))
    collection = collections(:sallys_favorite_collection)
    collection.user_id = users(:tom).id
    assert_strong_parameters(user, collection, collection.attributes.to_h,
                             %i[name description public user_id])
  end

  test 'admins can perform any action' do
    user = current_user(TokenHelper.for_user(users(:andrew), %w[show:collection
                                                                create:collection
                                                                update:collection
                                                                destroy:collection]))
    assert_permit(user, Collection, ANY_ACTION)
    assert_permit(user, collections(:toms_secret_collection), ANY_ACTION)
  end
end
