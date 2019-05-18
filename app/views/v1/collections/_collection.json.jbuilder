# frozen_string_literal: true

json.extract! collection, :id, :name, :description, :created_at, :updated_at, :user_id
json.unique_collectables_count collection.collectable_collections_count
json.images collection.images, partial: 'v1/images/image', as: :image if collection.association(:images).loaded?

json.collectable_collections_url v1_collection_collectable_collections_url(collection, format: :json)
json.images_url v1_collection_images_url(collection, format: :json)
json.url v1_collection_url(collection, format: :json)
