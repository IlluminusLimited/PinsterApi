# frozen_string_literal: true

json.extract! @image, :id, :name, :description, :featured, :imageable_type, :imageable_id, :base_file_name,
              :storage_location_uri, :created_at, :updated_at
