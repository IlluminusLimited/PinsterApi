# frozen_string_literal: true

require 'test_helper'

class CurrentUserFactoryTest < ActiveSupport::TestCase
  def test_can_evaluate_permissions
    user = users(:bob)

    assert_equal user.id, current_user(TokenHelper.for_user(user)).id
  end
end
