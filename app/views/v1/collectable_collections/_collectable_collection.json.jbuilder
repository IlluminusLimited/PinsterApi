# frozen_string_literal: true

json.extract! collectable_collection, :id, :count, :collectable_type, :collectable_id,
              :collection_id, :created_at, :updated_at
json.url v1_collectable_collection_url(collectable_collection, format: :json)
