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

  scope :with_counts, lambda {
    select <<~SQL
      collections.*,
      (
        SELECT COUNT(collectable_collections.id) FROM collectable_collections
        WHERE collection_id = collections.id
      ) AS counts
    SQL
  }

  scope :with_collectable_count, lambda {
    select <<~SQL
            collections.*,
            (
      SELECT json_object_agg(agg.collectable_type, agg.collectable_count)
      FROM (
             SELECT
               collectable_type,
               json_object_agg(results.collectable_id, results.collectable_count) AS collectable_count
             FROM (
                    SELECT
                      COUNT(collectable_id) AS collectable_count,
                      collectable_type,
                      collectable_id
                    FROM collectable_collections
                      INNER JOIN collections ON collection_id = collections.id
                    GROUP BY collectable_type, collectable_id) results
             GROUP BY results.collectable_type) agg) AS counted_collectables
    SQL
  }

  def collectable_count
    if respond_to?(:counted_collectables)
      HashWithIndifferentAccess.new(counted_collectables)
    else
      @counted_collectables = Collection.with_collectable_count.find(id).counted_collectables
      define_singleton_method :counted_collectables, -> { @counted_collectables }
      HashWithIndifferentAccess.new(@counted_collectables)
    end
  end

  def to_s
    "Collection: '#{id}:#{name}'"
  end
end
