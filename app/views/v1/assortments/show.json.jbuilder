# frozen_string_literal: true

json.partial! "v1/assortments/assortment", assortment: @assortment
if @collections.present?
  json.collections do
    json.array! @collections, partial: 'v1/collections/collection', as: :collection
  end
end