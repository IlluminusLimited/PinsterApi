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

class CollectableCollection < ApplicationRecord
  max_paginates_per 100

  belongs_to :collectable, polymorphic: true
  belongs_to :collection, counter_cache: true

  validates :collection_id, uniqueness: { scope: %i[collectable_type collectable_id] }

  scope :recently_added, -> { order(created_at: :desc) }
  scope :recently_updated, -> { order(updated_at: :desc) }

  def self.all_attribute_names
    private_attribute_names + public_attribute_names
  end

  def self.private_attribute_names
    %i[collectable_type collectable_id]
  end

  def self.public_attribute_names
    %i[count]
  end
end
