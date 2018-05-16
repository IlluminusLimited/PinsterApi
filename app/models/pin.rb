# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  tags        :jsonb            not null
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Pin < ApplicationRecord
  include Arel::Helpers

  has_many :images, as: :imageable, dependent: :destroy

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_one :pin_assortment, dependent: :destroy

  # scope :with_images, -> { includes(:images) }

  def images
    Image.select(Arel.star).where(
      Image[:imageable_id].eq(:assortment_id).and(Image[:imageable_type].eq('Assortment')).or(
        Image[:imageable_id].eq(:pin_id).and(Image[:imageable_type].eq('Pin'))
      )
    ).joins(
      Image.arel_table.join(Pin.arel_table).on(
        Pin[:id].eq(:imageable_id).and(Image[:imageable_type].eq('Pin'))
      ).join_sources
    ).joins(
      Image.arel_table.join(PinAssortment.arel_table).on(Pin[:id].eq(PinAssortment[:pin_id])).join_sources
    ).joins(
      Image.arel_table.join(Assortment.arel_table).on(
        Assortment[:id].eq(PinAssortment[:assortment_id])
      ).join_sources
    )
  end

  validates :name, presence: true
end
