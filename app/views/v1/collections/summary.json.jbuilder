# frozen_string_literal: true

json.array @collections do |collection|
  json.extract! collection, :id, :name
end
