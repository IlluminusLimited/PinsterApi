# frozen_string_literal: true

json.extract! assortment, :id, :name, :description, :tags, :created_at, :updated_at
json.images assortment.images, partial: 'v1/images/image', as: :image if assortment.association(:images).loaded?
json.pins assortment.pins, partial: 'v1/pins/pin', as: :pin if assortment.association(:pins).loaded?
json.images_url v1_assortment_images_url(assortment, format: :json)
json.url v1_assortment_url(assortment, format: :json)
