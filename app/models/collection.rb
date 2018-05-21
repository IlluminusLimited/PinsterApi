# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id                            :uuid             not null, primary key
#  collectable_collections_count :integer          default(0), not null
#  description                   :text
#  name                          :string           not null
#  public                        :boolean          default(TRUE), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :uuid
#
# Indexes
#
#  index_collections_on_user_id  (user_id)
#

class Collection < ApplicationRecord
  include Imageable
  extend EagerLoadable
  max_paginates_per 10

  has_many :collectable_collections, dependent: :destroy

  belongs_to :user

  accepts_nested_attributes_for :collectable_collections

  validates :name, presence: true
  validates :public, inclusion: { in: [true, false] }

  scope :with_images, -> { includes(:images) }
  scope :with_counts, -> { includes(collectable_collections: :collectable) }

  def collectable_count
    collectable_collections.sum(:count)
  end

  def to_s
    "Collection: '#{id}:#{name}'"
  end

  def self.default_result
    includes(:pins)
  end

  def self.build_query(params)
    if params[:images].nil? || params[:images].to_s == 'true'
      with_images.with_counts
    else
      default_result
    end
  end
end
