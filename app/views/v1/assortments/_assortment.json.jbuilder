# frozen_string_literal: true

json.extract! assortment, :id, :name, :description, :created_at, :updated_at
json.images assortment.images, partial: 'v1/images/image', as: :image
json.pins assortment.pins, partial: 'v1/pins/pin', as: :pin
json.url v1_assortment_url(assortment, format: :json)
