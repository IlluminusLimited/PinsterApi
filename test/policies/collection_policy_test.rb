# frozen_string_literal: true

require 'test_helper'

class CollectionPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'nil user cannot create collections' do
    user = nil
    assert_not_permitted(user, Collection, :create?)
  end

  test 'anybody can index collections' do
    user = nil
    assert_permit(user, Collection, :index?)
  end

  test 'users cannot view private collections' do
    user = users(:sally)
    assert_not_permitted(user, collections(:toms_secret_collection), :show?)
  end

  test 'users can view their private collections' do
    user = users(:tom)
    assert_permit(user, collections(:toms_secret_collection), :show?)
  end

  test 'users can create collections' do
    user = users(:sally)
    assert_permit(user, Collection, :create?)
  end

  test 'users can perform any instance action to their collections' do
    user = users(:sally)
    assert_permit(user, collections(:sallys_favorite_collection), ANY_INSTANCE_ACTION)
  end

  test 'users cannot alter other users collections' do
    user = users(:sally)
    assert_not_permitted(user, collections(:toms_keepers_collection), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    assert_permit(user, Collection, ANY_ACTION)
    assert_permit(user, collections(:toms_secret_collection), ANY_ACTION)
  end
end
