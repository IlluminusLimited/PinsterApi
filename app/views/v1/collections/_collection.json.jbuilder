# frozen_string_literal: true

json.extract! collection, :id, :name, :description, :created_at, :updated_at
json.url v1_collection_url(collection, format: :json)
