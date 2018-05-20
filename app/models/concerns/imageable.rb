# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :images, as: :imageable, dependent: :destroy
  end

  def images_or_placeholder
    images.size.positive? ? images : [placeholder]
  end

  def placeholder
    file = Faker::Placeholdit.image("300x300", 'jpeg')
    file_name = file.match(/\d+x\d+/)[0]
    Image.new(imageable: self,
              base_file_name: file_name,
              storage_location_uri: file,
              thumbnailable: false)
  end
end
