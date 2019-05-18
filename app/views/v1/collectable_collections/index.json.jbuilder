# frozen_string_literal: true

json.links do
  json.pages! @collectable_collections, url: request.original_url
end

json.data do
  json.array! @collectable_collections,
              partial: 'v1/collectable_collections/collectable_collection',
              as: :collectable_collection
end
