# frozen_string_literal: true

json.partial! "v1/pins/pin", pin: @pin

if @collectable_collections.present?
  json.collectable_collections do
    json.array! @collectable_collections,
                partial: 'v1/collectable_collections/collectable_collection',
                as: :collectable_collection
  end
end
