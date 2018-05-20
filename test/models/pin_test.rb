# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  tags        :jsonb            not null
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PinTest < ActiveSupport::TestCase
  test 'a pin can get images from its assortment' do
    images = pins(:wisconsin_unicorn).all_images
    assert_includes(images, images(:wisconsin_assortment_main_image))
    assert_includes(images, images(:wisconsin_unicorn_image))
  end
end
