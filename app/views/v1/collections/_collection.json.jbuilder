# frozen_string_literal: true

json.extract! collection, :id, :name, :description, :created_at, :updated_at, :user_id
json.collectable_collections collection.collectable_collections,
                             partial: 'v1/collectables/collectable',
                             as: :collectable_collection
json.images collection.images, partial: 'v1/images/image', as: :image
json.url v1_collection_url(collection, format: :json)
