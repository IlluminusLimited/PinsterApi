# frozen_string_literal: true

require 'test_helper'

class UserPolicyTest < PolicyAssertions::Test
  include PolicyTestHelper

  test 'anon user cannot create or modify themselves' do
    user = User.anon_user
    assert_not_permitted(user, user, ANY_INSTANCE_MODIFY_ACTION)
  end

  test 'user can modify themselves' do
    user = users(:sally)
    assert_permit(user, user, :update?)
  end

  test 'user cannot change their role' do
    user = users(:sally)
    new_user = user.dup
    new_user.role = 1
    assert_strong_parameters(user, new_user, new_user.attributes.to_h, %i[bio display_name email verified])
  end

  test 'admin can change roles' do
    user = users(:andrew)
    new_user = users(:sally)
    new_user.role = 1
    assert_strong_parameters(user, new_user, new_user.attributes.to_h, %i[bio display_name email verified role])
  end
end
