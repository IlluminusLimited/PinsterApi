# frozen_string_literal: true

require 'test_helper'

class CurrentUserTest < ActiveSupport::TestCase
  def test_can_evaluate_permissions
    assert CurrentUser.new(User.anon_user)
      .with_permissions(['show:collections'])
                      .can?('show:collections')
  end
end
