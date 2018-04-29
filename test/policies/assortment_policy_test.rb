# frozen_string_literal: true

require 'test_helper'

class AssortmentPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'nil user cannot create assortments' do
    user = nil
    assert_not_permitted(user, Assortment, ANY_CREATE_ACTION)
  end

  test 'nil user can view assortments' do
    user = nil
    assert_permit(user, Assortment, ANY_VIEW_ACTION)
  end

  test 'users can view assortments' do
    user = users(:sally)
    assert_permit(user, Assortment, ANY_VIEW_ACTION)
    assert_permit(user, assortments(:wisconsin_2009), ANY_VIEW_ACTION)
  end

  test 'users cannot create or modify assortments' do
    user = users(:sally)
    assert_not_permitted(user, Assortment, ANY_CREATE_ACTION)
    assert_not_permitted(user, assortments(:wisconsin_2009), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'moderators can perform any action' do
    user = users(:bob)
    assert_permit(user, Assortment, ANY_ACTION)
    assert_permit(user, assortments(:wisconsin_2009), ANY_ACTION)
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    assert_permit(user, Assortment, ANY_ACTION)
    assert_permit(user, assortments(:wisconsin_2009), ANY_ACTION)
  end
end
