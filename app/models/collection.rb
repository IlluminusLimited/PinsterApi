# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id                            :uuid             not null, primary key
#  collectable_collections_count :integer          default(0), not null
#  description                   :text
#  images_count                  :integer          default(0), not null
#  name                          :string           not null
#  public                        :boolean          default(TRUE), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :uuid
#
# Indexes
#
#  index_collections_on_created_at    (created_at)
#  index_collections_on_images_count  (images_count)
#  index_collections_on_user_id       (user_id)
#

class Collection < ApplicationRecord
  extend EagerLoadable
  max_paginates_per 100

  has_many :images, as: :imageable, dependent: :destroy
  has_many :collectable_collections, dependent: :destroy

  belongs_to :user

  accepts_nested_attributes_for :collectable_collections

  validates :name, presence: true
  validates :public, inclusion: { in: [true, false] }

  scope :recently_added, -> { order(created_at: :desc) }
  scope :with_images, -> { includes(:images) }
  scope :with_counts, -> { includes(:collectable_collections) }

  def collectable_count
    collectable_collections.sum(:count)
  end

  def fetch_more_images
    # collectable_collections.joins(:images).where
  end

  def to_s
    "Collection: '#{id}:#{name}'"
  end

  def self.default_result
    includes(:pins).recently_added
  end

  def self.build_query(params)
    if params[:images].nil? || params[:images].to_s == 'true'
      with_images.recently_added
    else
      default_result.recently_added
    end
  end
end
