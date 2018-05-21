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
# Indexes
#
#  index_pins_on_created_at  (created_at)
#

class Pin < ApplicationRecord
  include PgSearch
  include Imageable
  extend EagerLoadable

  multisearchable against: %i[name description], using: { tsearch: { dictionary: "english" } }

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_one :pin_assortment, dependent: :destroy
  has_one :assortment, through: :pin_assortment

  scope :recently_added, -> { order(created_at: :desc) }
  scope :with_images, -> { includes(:images) }
  scope :with_counts, lambda {
    select <<~SQL
      pins.*,
      (
        SELECT COUNT(images.id) FROM images
        WHERE imageable_type = 'Pin' AND imageable_id = pins.id
      ) AS counts
    SQL
  }

  validates :name, presence: true

  def all_images
    Image.find_by_sql <<~SQL
      select images.*
      from images
        inner join pins on imageable_id = pins.id
      where imageable_id = '#{id}' and imageable_type = 'Pin'
      union
      select images.*
      from images
        inner join assortments on imageable_id = assortments.id and imageable_type = 'Assortment'
        inner join pin_assortments on pin_assortments.assortment_id = assortments.id
      where pin_id ='#{id}';
    SQL
  end

  def self.default_result
    includes(:images).includes(:assortment).recently_added
  end

  def self.build_query(params)
    if params[:all_images]
      with_counts.recently_added
    elsif params[:images].nil? || params[:images].to_s == 'true'
      includes(:assortment).with_images.with_counts.recently_added
    else
      default_result
    end
  end
end
