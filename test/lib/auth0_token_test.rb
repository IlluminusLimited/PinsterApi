# frozen_string_literal: true

require 'test_helper'

class Auth0TokenTest < ActiveSupport::TestCase
  def test_can_look_up_user
    user = users(:bob)
    token = Auth0Token.new("sub" => user.external_user_id)
    assert_equal user.id, token.to_current_user.id
  end

  def test_returns_anon_when_lookup_fails
    token = Auth0Token.new("sub" => 'asdfa')
    assert_nil token.to_current_user.id
    assert_not token.to_current_user.user?
  end
end
