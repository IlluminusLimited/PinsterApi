# frozen_string_literal: true

json.extract! image, :id, :featured, :storage_location_uri, :thumbnailable
json.url v1_image_url(image, format: :json) if image.id.present?
