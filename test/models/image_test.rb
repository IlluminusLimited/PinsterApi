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
#  thumbnailable        :boolean          default(TRUE), not null
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
  test 'base_file_name must be included in storage_location_uri' do
    image = images(:texas_dragon_image_one)
    assert image.valid?
    assert image.storage_location_uri.include?(image.base_file_name)
    image.base_file_name = 'gibberish'
    assert_not image.valid?
  end

  test 'images are always returned in order by featured' do
    assert_equal Image.all.order(featured: :desc).to_sql, Image.all.to_sql
  end

  test 'imageables do not get placeholder if no images present' do
    placeholder_image = Pin.new.images.first
    assert_nil placeholder_image
  end
end
