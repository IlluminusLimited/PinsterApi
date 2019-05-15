# frozen_string_literal: true

json.extract! @image, :imageable_type, :imageable_id
json.image_service_token @image_service_token
json.image_service_url @image_service_url
