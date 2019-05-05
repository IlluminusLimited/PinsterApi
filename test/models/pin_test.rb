# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id           :uuid             not null, primary key
#  description  :text
#  images_count :integer          default(0), not null
#  name         :string           not null
#  tags         :jsonb            not null
#  year         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pins_on_created_at    (created_at)
#  index_pins_on_images_count  (images_count)
#

require 'test_helper'

class PinTest < ActiveSupport::TestCase
  test 'a pin can get images from its assortment' do
    images = pins(:wisconsin_unicorn).all_images
    assert_includes(images, images(:wisconsin_assortment_main_image))
    assert_includes(images, images(:wisconsin_unicorn_image))
  end

  test 'pins are sorted by created at :desc' do
    assert_equal Pin.order(year: :desc, created_at: :desc).to_sql, Pin.recently_added.all.to_sql
  end
end
