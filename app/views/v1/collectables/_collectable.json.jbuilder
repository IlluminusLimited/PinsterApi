# frozen_string_literal: true

json.extract! collectable, :id
json.images collectable.images, partial: 'v1/images/image', as: :image
json.url v1_collection_url(collection, format: :json)
