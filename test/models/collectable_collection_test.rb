# frozen_string_literal: true

# == Schema Information
#
# Table name: collectables
#
#  id               :uuid             not null, primary key
#  collectable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  collectable_id   :uuid
#  collection_id    :uuid
#
# Indexes
#
#  index_collectable_collections_on_collection_id  (collection_id)
#

require 'test_helper'

class CollectableCollectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
