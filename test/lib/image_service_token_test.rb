# frozen_string_literal: true

require 'test_helper'

class ImageServiceTokenTest < ActiveSupport::TestCase
  def test_validates_payload
    expected = ImageServiceToken.new("imageable_id" => 1, "imageable_type" => 'Bob')
    assert_equal 1, expected.imageable_id
    assert_equal 'Bob', expected.imageable_type
  end

  def test_can_pull_out_imageable_stuff
    expected = ImageServiceToken.new("imageable_id" => 1, "imageable_type" => 'Bob')
    assert_equal 1, expected.imageable_id
    assert_equal 'Bob', expected.imageable_type
  end

  def test_only_owns_imageable
    imageable = pins(:texas_dragon)
    expected = ImageServiceToken.new("imageable_id" => imageable.id, "imageable_type" => 'Pin')
    assert expected.owns?(imageable)

    imageable = pins(:massachusetts_crab)
    assert_not expected.owns?(imageable)
  end
end
