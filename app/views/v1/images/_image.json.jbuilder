# frozen_string_literal: true

json.extract! image, :id, :name, :description, :featured, :base_file_name, :storage_location_uri,
              :imageable_type, :imageable_id, :created_at, :updated_at
json.url v1_image_url(image, format: :json)
