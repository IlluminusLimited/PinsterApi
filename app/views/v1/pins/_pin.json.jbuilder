# frozen_string_literal: true

json.extract! pin, :id, :name, :year, :description, :created_at, :updated_at
json.url v1_pin_url(pin, format: :json)
