# frozen_string_literal: true

# == Schema Information
#
# Table name: collectable_collections
#
#  id               :uuid             not null, primary key
#  collectable_type :string
#  count            :integer          default(1), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  collectable_id   :uuid
#  collection_id    :uuid
#
# Indexes
#
#  index_collectable_collections_on_collection_id  (collection_id)
#  index_on_collectable_collection_unique          (collectable_type,collectable_id,collection_id) UNIQUE
#

require 'test_helper'

class CollectableCollectionTest < ActiveSupport::TestCase
  setup do
    @one = collectable_collections(:sallys_favorite_dragon_collectables)
    @two = collectable_collections(:toms_keeper_2009_assortments)
    @three = collectable_collections(:toms_secret_unicorn_collectables)
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
  end

  test 'can add to a collection' do
  end
end
