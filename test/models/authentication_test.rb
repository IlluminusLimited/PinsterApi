# frozen_string_literal: true

# == Schema Information
#
# Table name: authentications
#
#  id               :uuid             not null, primary key
#  provider         :string           not null
#  token            :string           default("")
#  token_expires_at :datetime
#  uid              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :uuid             not null
#
# Indexes
#
#  index_authentications_on_user_id  (user_id)
#

require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  setup do
    @sally_token = authentications(:sally_token)
    @tom_token = authentications(:tom_token)
  end

  test 'a token can be refreshed' do
    assert_not @sally_token.token_valid?
    assert @sally_token.refresh_token.token_valid?
  end
end
