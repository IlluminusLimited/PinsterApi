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

  test 'imageables can get placeholder if no images present' do
    placeholder_image = Pin.new.images_or_placeholder.first
    assert_match '300x300', placeholder_image.storage_location_uri
    assert_equal false, placeholder_image.thumbnailable
  end

  test 'images will update images_count on imageable' do
    file = Faker::Placeholdit.image("300x300", 'jpeg')
    file_name = file.match(/\d+x\d+/)[0]
    Image.create!(imageable: images(:texas_dragon_image_one).imageable,
                  base_file_name: file_name,
                  storage_location_uri: file,
                  thumbnailable: false)
    assert_equal 2, images(:texas_dragon_image_one).imageable.images_count
  end
end
