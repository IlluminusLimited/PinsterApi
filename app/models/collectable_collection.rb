# frozen_string_literal: true

# == Schema Information
#
# Table name: collectable_collections
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

class CollectableCollection < ApplicationRecord
  belongs_to :collectable, polymorphic: true
  belongs_to :collection
end
