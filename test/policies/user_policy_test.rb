# frozen_string_literal: true

require 'test_helper'

class UserPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create or modify themselves' do
    user = CurrentUser.new(User.anon_user)
    assert user.anonymous?
    assert_not_permitted(user, user, ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'user can modify themselves' do
    user = current_user(TokenHelper.for_user(users(:sally)))
    assert_permit(user, user, :update?)
  end
end
