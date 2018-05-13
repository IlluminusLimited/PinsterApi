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

class Collection < ApplicationRecord
  has_many :images, as: :imageable, dependent: :destroy

  has_many :collectable_collections, dependent: :destroy

  belongs_to :user

  accepts_nested_attributes_for :collectable_collections

  validates :name, presence: true
  validates :public, presence: true

  scope :with_counts, -> {
    select <<~SQL
      collections.*,
      (
        SELECT COUNT(collectable_collections.id) FROM collectable_collections
        WHERE collection_id = collections.id
      ) AS collectable_count
    SQL
  }

  scope :with_collectable_count, -> {
    select <<~SQL
            collections.*,
            (
      select json_object_agg(agg.collectable_type, agg.collectable_count)
      from (
             select
               collectable_type,
               json_object_agg(results.collectable_id, results.collectable_count) as collectable_count
             from (
                    select
                      count(collectable_id) as collectable_count,
                      collectable_type,
                      collectable_id
                    from collectable_collections
                      inner join collections on collection_id = collections.id
                    group by collectable_type, collectable_id) results
             group by results.collectable_type) agg) AS collectable_count
    SQL
  }

  def to_s
    "Collection: '#{id}:#{name}'"
  end
end
