# frozen_string_literal: true

# == Schema Information
#
# Table name: collectable_collections
#
#  id               :uuid             not null, primary key
#  collectable_type :uuid
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
  # test "the truth" do
  #   assert true
  # end
end
