# frozen_string_literal: true

# == Schema Information
#
# Table name: assortments
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Assortment < ApplicationRecord
  include PgSearch
  include Imageable
  extend EagerLoadable

  multisearchable against: %i[name description], using: { tsearch: { dictionary: "english" } }

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_many :pin_assortments, dependent: :destroy

  has_many :pins, through: :pin_assortments

  accepts_nested_attributes_for :collectable_collections
  accepts_nested_attributes_for :pin_assortments

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
