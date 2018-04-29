
# frozen_string_literal: true

require 'test_helper'

class PinPolicyTest < PolicyAssertions::Test
  test 'nil user cannot create pins' do
    user = nil
    assert_not_permitted(user, Pin, %i[new? create?])
  end

  test 'users can create pins' do
    user = users(:sally)
    assert_permit(user, Pin, %i[new? create?])
  end

  test 'moderators can update and delete pins' do
    user = users(:bob)
    assert_permit(user, Pin, %i[update? destroy?])
  end

  test 'users cannot update and delete pins' do
    user = users(:sally)
    assert_not_permitted(user, Pin, %i[update? destroy?])
  end

  test 'admins can perform any action' do
    user = users(:andrew)
    assert_permit(user, Pin, %i[new? create? update? destroy?])
  end
end
