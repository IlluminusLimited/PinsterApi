# frozen_string_literal: true

json.extract! pin, :id, :name, :year, :description, :tags, :created_at, :updated_at
if pin.association(:images).loaded?
  json.images pin.images_or_placeholder, partial: 'v1/images/image', as: :image
end
json.url v1_pin_url(pin, format: :json)
