# frozen_string_literal: true

json.extract! pin, :id, :name, :year, :description, :tags, :created_at, :updated_at
json.images pin.images, partial: 'v1/images/image', as: :image
json.url v1_pin_url(pin, format: :json)
