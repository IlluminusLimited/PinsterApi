# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id           :uuid             not null, primary key
#  description  :text
#  images_count :integer          default(0), not null
#  name         :string           not null
#  published    :boolean          default(FALSE), not null
#  tags         :jsonb            not null
#  year         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pins_on_images_count         (images_count)
#  index_pins_on_year_and_created_at  (year,created_at)
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

  test 'published pins only contain published pins' do
    assert_difference('Pin.with_published.count', +1) do
      Pin.create!(name: 'pin', published: true)
    end
  end

  def test_pin_search_can_use_partial_words
    results = Pin.simple_search('time')
    assert_equal 2, results.size,
                 "Two pins should be present since this query doesn't use published restrictions"
  end

  def test_pin_search_can_use_partial_years
    results = Pin.simple_search('200')
    assert_equal 2, results.size,
                 "Two pins should be present since 200 matches only 2009 fixtures"
  end

  def test_pin_search_can_use_partial_years
    results = Pin.simple_search('2017')
    assert_equal 1, results.size,
                 "One pin should be present since 2017 matches only ohio_cow"
  end

  def test_pin_search_can_use_whole_words
    results = Pin.simple_search('timeless')
    assert_equal 1, results.size, "Only one unpublished pin should be returned"
  end

  def test_pin_search_ranks_results
    results = Pin.simple_search('dawn of time')
    assert_equal 2, results.size, "Time should match two pins"
    assert_equal pins(:texas_dragon).id, results.first.id,
                 "Texas dragon should be first since 'dawn of time' is a direct match"
  end
end
