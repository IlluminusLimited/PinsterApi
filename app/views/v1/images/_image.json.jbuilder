# frozen_string_literal: true

# json.extract! image, :id, :base_file_name, :description, :featured, :imageable_type, :imageable_id, :name,
#               :storage_location_uri, :created_at, :updated_at
json.extract! image, :id, :featured
json.url v1_image_url(image, format: :json)
