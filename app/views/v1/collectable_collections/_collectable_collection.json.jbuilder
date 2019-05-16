# frozen_string_literal: true

json.extract! collectable_collection, :id, :count, :collectable_type, :collectable_id,
              :collection_id, :created_at, :updated_at

if collectable_collection.association(:collectable).loaded?
  json.collectable do
    json.partial! collectable_collection.collectable
  end
end
json.collection_url v1_collection_url(collectable_collection.collection)
json.url v1_collectable_collection_url(collectable_collection, format: :json)
