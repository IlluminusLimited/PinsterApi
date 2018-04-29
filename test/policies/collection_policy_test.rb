# frozen_string_literal: true

require 'test_helper'

class CollectionPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'nil user cannot create collections' do
    user = nil
    assert_not_permitted(user, Collection, ANY_CREATE_ACTION)
  end

  test 'nil user cannot view collections' do
    user = nil
    assert_not_permitted(user, Collection, ANY_VIEW_ACTION)
  end

  test 'users can create collections' do
    user = users(:sally)
    assert_permit(user, Collection, ANY_CREATE_ACTION)
  end

  test 'users can perform any instance action to their collections' do
    user = users(:sally)
    assert_permit(user, collections(:sallys_favorite_collection), ANY_INSTANCE_ACTION)
  end

  test 'users cannot alter other users collections' do
    user = users(:sally)
    assert_not_permitted(user, collections(:toms_keepers_collection), ANY_INSTANCE_ALTER_ACTION)
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    assert_permit(user, Collection, ANY_ACTION)
  end
end
