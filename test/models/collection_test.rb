# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  public      :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_collections_on_user_id  (user_id)
#

require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  setup do
    @sallys_favorite_collection = collections(:sallys_favorite_collection)
    @toms_keepers_collection = collections(:toms_keepers_collection)
  end

  test 'fixtures are valid' do
    assert @sallys_favorite_collection.valid?
    assert @toms_keepers_collection.valid?
  end

  test 'a collection can contain both pins and assortments of pins' do
    collection = Collection.create!(name: 'Amazing collection',
                                    user: users(:sally),
                                    collectable_collections_attributes: [
                                      { collectable: Pin.create!(name: 'thing', year: 1998) },
                                      { collectable:
                                           Assortment.create!(name: 'amazing pin set',
                                                              pin_assortments_attributes: [
                                                                {
                                                                  pin: pins(:texas_dragon)
                                                                }
                                                              ]) }
                                    ])
    assert collection.valid?
  end

  # test collection members respond to images method and return an array of images
end
