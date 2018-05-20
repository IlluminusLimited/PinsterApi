# frozen_string_literal: true

json.extract! assortment, :id, :name, :description, :tags, :created_at, :updated_at
if assortment.association(:images).loaded?
  json.images assortment.images_or_placeholder, partial: 'v1/images/image', as: :image
end
json.pins assortment.pins, partial: 'v1/pins/pin', as: :pin if assortment.association(:pins).loaded?
json.url v1_assortment_url(assortment, format: :json)
