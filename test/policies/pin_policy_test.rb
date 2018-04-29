# frozen_string_literal: true

require 'test_helper'

class PinPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'nil user cannot create or modify pins' do
    user = nil
    assert_not_permitted(user, Pin, :create?)
    assert_not_permitted(user, pins(:texas_dragon), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users cannot create pins' do
    user = users(:sally)
    assert_not_permitted(user, Pin, :create?)
  end

  test 'users cannot modify pins' do
    user = users(:sally)
    assert_not_permitted(user, pins(:texas_dragon), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'moderators can modify pins' do
    user = users(:bob)
    assert_permit(user, Pin, ANY_INSTANCE_MODIFY_ACTION)
    assert_permit(user, pins(:texas_dragon), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    assert_permit(user, Pin, ANY_ACTION)
    assert_permit(user, pins(:texas_dragon), ANY_ACTION)
  end
end
