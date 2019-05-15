# frozen_string_literal: true

json.extract! @image, :name, :description, :featured, :imageable_type, :imageable_id
json.image_service_token @image_service_token
