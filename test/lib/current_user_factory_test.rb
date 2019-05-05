# frozen_string_literal: true

require 'test_helper'

class CurrentUserFactoryTest < ActiveSupport::TestCase
  def test_can_evaluate_permissions
    assert_not CurrentUser.new(User.anon_user).can?('show:collections')
  end
end
