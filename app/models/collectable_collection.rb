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

class CollectableCollection < ApplicationRecord
  belongs_to :collectable, polymorphic: true
  belongs_to :collection

  def self.public_attribute_names
    %i[collectable_id collectable_type collection_id]
  end
end
