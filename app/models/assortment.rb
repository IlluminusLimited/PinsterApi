# frozen_string_literal: true

# == Schema Information
#
# Table name: assortments
#
#  id           :uuid             not null, primary key
#  description  :text
#  images_count :integer          default(0), not null
#  name         :string
#  published    :boolean          default(FALSE), not null
#  tags         :jsonb            not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_assortments_on_created_at    (created_at)
#  index_assortments_on_images_count  (images_count)
#

class Assortment < ApplicationRecord
  include PgSearch::Model
  extend EagerLoadable

  pg_search_scope :simple_search,
                  against: %i[name description year],
                  using: {
                    tsearch: {
                      dictionary: "english",
                      prefix: true,
                      any_word: true
                    },
                    trigram: {
                      only: %i[name description],
                      word_similarity: true
                    }
                  },
                  ranked_by: ":trigram",
                  order_within_rank: "assortments.updated_at DESC"

  multisearchable against: %i[name description year],
                  using: { tsearch: { dictionary: "english" } },
                  if: :published?

  has_many :images, as: :imageable, dependent: :destroy
  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_many :pin_assortments, dependent: :destroy

  has_many :pins, through: :pin_assortments

  accepts_nested_attributes_for :collectable_collections
  accepts_nested_attributes_for :pin_assortments

  scope :with_published, -> { where(published: true) }
  scope :recently_added, -> { order(created_at: :desc) }
  scope :with_images, lambda {
                        includes(:images)
                          .includes(:pin_assortments)
                          .includes(:pins)
                          .includes(pin_assortments: [pin: :images])
                      }
  scope :with_counts, lambda {
    select <<~SQL
      assortments.*,
      (
        SELECT COUNT(pins.id) FROM pins
        INNER JOIN pin_assortments ON assortment_id = assortments.id
        WHERE assortment_id = assortments.id
      ) AS counts
    SQL
  }

  def to_s
    "Assortment(Set): '#{id}:#{name}'"
  end

  def self.default_result
    includes(:pins)
  end
end
