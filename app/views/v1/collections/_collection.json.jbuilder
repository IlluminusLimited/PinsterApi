# frozen_string_literal: true

json.extract! collection, :id, :name, :description, :created_at, :updated_at, :user_id
json.collectables collection.collectable_collections,
                  partial: 'v1/collectable_collections/collectable_collection',
                  as: :collectable_collection if collection.association(:collectable_collections).loaded?
json.images collection.images, partial: 'v1/images/image', as: :image if collection.association(:images).loaded?
json.url v1_collection_url(collection, format: :json)
