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
  has_many :images, as: :imageable, dependent: :destroy

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_one :pin_assortment, dependent: :destroy
  has_one :assortment, through: :pin_assortment

  scope :with_images, -> { includes(:images) }

  validates :name, presence: true

  def images
    Image.find_by_sql <<~SQL
                select images.id as id,
        images.description,
        imageable_type,
        imageable_id,
        images.name,
        base_file_name,
        storage_location_uri,
        images.created_at,
        images.updated_at,
        featured
      from images
        inner join pins on imageable_id = pins.id
      where imageable_id = '#{id}' and imageable_type = 'Pin'
      union
      select  images.id as id,
        images.description,
        imageable_type,
        imageable_id,
        images.name,
        base_file_name,
        storage_location_uri,
        images.created_at,
        images.updated_at,
        featured
      from images
        inner join assortments on imageable_id = assortments.id and imageable_type = 'Assortment'
        inner join pin_assortments on pin_assortments.assortment_id = assortments.id
      where pin_id ='#{id}';
    SQL
  end
end
