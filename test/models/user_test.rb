# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id           :uuid             not null, primary key
#  bio          :text
#  display_name :string
#  email        :string           not null
#  images_count :integer          default(0), not null
#  role         :integer          default(3), not null
#  verified     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_email         (email) UNIQUE
#  index_users_on_images_count  (images_count)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # test email is required
  # test roles resolve correctly
  # test admin cannot be set outside of database seed (maybe?), maybe create validation or something that prevents it
end
