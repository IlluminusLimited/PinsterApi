# frozen_string_literal: true

json.extract! @image, :id, :name, :description, :featured, :imageable_type, :imageable_id, :base_file_name,
              :storage_location_uri, :created_at, :updated_at, :thumbnailable
json.image_service_token @image_service_token if @image_service_token
json.url v1_image_url(@image, format: :json) if @image.id.present?
