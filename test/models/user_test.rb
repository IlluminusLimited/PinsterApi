# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :uuid             not null, primary key
#  bio              :text
#  display_name     :string
#  images_count     :integer          default(0), not null
#  verified         :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :text             not null
#
# Indexes
#
#  index_users_on_external_user_id  (external_user_id) UNIQUE
#  index_users_on_images_count      (images_count)
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
