# frozen_string_literal: true

require 'test_helper'

class AssortmentPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create assortments' do
    user = CurrentUser.new(User.anon_user)
    assert_not_permitted(user, Assortment, :create?)
  end

  test 'anon user can view assortments' do
    user = CurrentUser.new(User.anon_user)
    assert_permit(user, Assortment, ANY_VIEW_ACTION)
  end

  test 'users can view assortments' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, Assortment, ANY_VIEW_ACTION)
    assert_permit(user, assortments(:wisconsin_2009), ANY_VIEW_ACTION)
  end

  test 'users cannot create or modify assortments' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, Assortment, :create?)
    assert_not_permitted(user, assortments(:wisconsin_2009), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'moderators can perform any action' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[create:assortment update:assortment destroy:assortment]))
    assert_permit(user, Assortment, ANY_ACTION)
    assert_permit(user, assortments(:wisconsin_2009), ANY_ACTION)
  end

  test 'admins can perform any action' do
    user = current_user(TokenHelper.for_user(users(:andrew), %w[create:assortment update:assortment destroy:assortment]))
    assert_permit(user, Assortment, ANY_ACTION)
    assert_permit(user, assortments(:wisconsin_2009), ANY_ACTION)
  end
end
