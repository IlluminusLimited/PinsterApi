# frozen_string_literal: true

json.extract! collectable_collection, :id, :count
json.collectable do
  json.partial! collectable_collection.collectable
end
json.collectable_type collectable_collection.collectable_type
json.url v1_collectable_collection_url(collectable_collection, format: :json)
