# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id                   :uuid             not null, primary key
#  base_file_name       :text             not null
#  description          :text
#  featured             :datetime
#  imageable_type       :string
#  name                 :string
#  storage_location_uri :text             not null
#  thumbnailable        :boolean          default(TRUE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  imageable_id         :uuid
#
# Indexes
#
#  index_images_on_featured                         (featured)
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

class Image < ApplicationRecord
  belongs_to :imageable, counter_cache: :images_count, polymorphic: true

  validates :storage_location_uri, presence: true, allow_blank: false
  validates :base_file_name, inclusion: { in: :storage_location_uri }, allow_blank: false

  default_scope { order(featured: :desc) }

  def self.private_attribute_names
    %i[imageable_id imageable_type base_file_name storage_location_uri thumbnailable]
  end

  def self.public_attribute_names
    %i[description featured name]
  end
end
