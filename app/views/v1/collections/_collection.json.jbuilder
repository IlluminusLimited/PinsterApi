# frozen_string_literal: true

json.extract! collection, :id, :name, :description, :created_at, :updated_at, :user_id
json.url v1_collection_url(collection, format: :json)
