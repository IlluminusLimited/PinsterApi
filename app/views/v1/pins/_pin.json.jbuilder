# frozen_string_literal: true

json.extract! pin, :id, :name, :year, :description, :tags, :created_at, :updated_at

if pin.association(:assortment).loaded? && pin.assortment.present?
  json.assortment_url v1_assortment_url(pin.assortment, format: :json)
end

if @images.present?
  json.images @images, partial: 'v1/images/image', as: :image
elsif pin.association(:images).loaded?
  json.images pin.images, partial: 'v1/images/image', as: :image
end
json.url v1_pin_url(pin, format: :json)
