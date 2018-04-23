# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id                   :uuid             not null, primary key
#  base_file_name       :text             not null
#  description          :text
#  featured             :datetime
#  imageable_type       :string
#  name                 :string
#  storage_location_uri :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  imageable_id         :uuid
#
# Indexes
#
#  index_images_on_featured                         (featured)
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
