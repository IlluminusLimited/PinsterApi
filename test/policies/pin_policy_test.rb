# frozen_string_literal: true

require 'test_helper'

class PinPolicyTest < PolicyAssertions::Test
  ANY_ACTION = %i[index? show? create? update? destroy? publish?].freeze
  ANY_VIEW_ACTION = %i[index? show?].freeze
  ANY_INSTANCE_ACTION = %i[show? update? destroy? publish?].freeze
  ANY_INSTANCE_MODIFY_ACTION = %i[update? destroy? publish?].freeze

  test 'anon user cannot create or modify pins' do
    user = CurrentUser.new(User.anon_user)
    assert_not_permitted(user, Pin, :create?)
    assert_not_permitted(user, pins(:texas_dragon), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'users cannot create pins' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, Pin, :create?)
  end

  test 'users cannot modify pins' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_not_permitted(user, pins(:texas_dragon), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'moderators can modify pins' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[create:pin update:pin destroy:pin publish:pin]))
    assert_permit(user, Pin, ANY_INSTANCE_MODIFY_ACTION)
    assert_permit(user, pins(:texas_dragon), ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'admins can perform any action' do
    user = current_user(TokenHelper.for_user(users(:bob), %w[create:pin update:pin destroy:pin publish:pin]))
    assert_permit(user, Pin, ANY_ACTION)
    assert_permit(user, pins(:texas_dragon), ANY_ACTION)
  end
end
