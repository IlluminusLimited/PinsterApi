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
  test 'a pin inherits images from its assortment' do
    @pin = pins(:wisconsin_unicorn)
    assert_includes(@pin.all_images, images(:wisconsin_assortment_main_image))
  end
end
