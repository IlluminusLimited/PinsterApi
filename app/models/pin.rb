# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id           :uuid             not null, primary key
#  description  :text
#  images_count :integer          default(0), not null
#  name         :string           not null
#  published    :boolean          default(FALSE), not null
#  tags         :jsonb            not null
#  year         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pins_on_images_count         (images_count)
#  index_pins_on_year_and_created_at  (year,created_at)
#

class Pin < ApplicationRecord
  include PgSearch::Model
  extend EagerLoadable
  max_paginates_per 200
  has_paper_trail

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
                  order_within_rank: "pins.updated_at DESC"

  multisearchable against: %i[name description year],
                  using: { tsearch: { dictionary: "english" } },
                  if: :published?

  has_many :images, as: :imageable, dependent: :destroy
  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_one :pin_assortment, dependent: :destroy
  has_one :assortment, through: :pin_assortment

  scope :with_published, -> { where(published: true) }
  scope :recently_added, -> { order(year: :desc, created_at: :desc) }
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

  def self.all_attribute_names
    public_attribute_names + restricted_attribute_names
  end

  def self.restricted_attribute_names
    %i[published]
  end

  def self.public_attribute_names
    %i[name description year]
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
