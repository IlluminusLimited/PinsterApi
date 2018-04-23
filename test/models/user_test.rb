# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :uuid             not null, primary key
#  bio          :text
#  display_name :string
#  email        :string           not null
#  role         :integer          default("user"), not null
#  verified     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # test email is required
  # test roles resolve correctly
  # test user with __ role can ___
  # test user without __ role cannot __
  # test admin user can edit other user roles
  # test user without admin cannot edit roles
  # test admin cannot be set outside of database seed (maybe?), maybe create validation or something that prevents it
  #
end
