# frozen_string_literal: true

json.extract! assortment, :id, :id, :name, :description, :created_at, :updated_at
json.url v1_assortment_url(assortment, format: :json)
