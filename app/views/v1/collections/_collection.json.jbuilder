# frozen_string_literal: true

json.extract! collection, :id, :name, :description, :created_at, :updated_at, :user_id
json.unique_collectables_count collection.collectable_collections_count
if collection.association(:collectable_collections).loaded?
  json.total_collectables_count collection.collectable_count
  json.collectables collection.collectable_collections,
                    partial: 'v1/collectable_collections/collectable_collection',
                    as: :collectable_collection
end
if collection.association(:images).loaded?
  json.images collection.images_or_placeholder, partial: 'v1/images/image', as: :image
end
json.url v1_collection_url(collection, format: :json)
