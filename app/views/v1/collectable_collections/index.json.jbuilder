# frozen_string_literal: true

json.array! @collectable_collections,
            partial: 'v1/collectable_collections/collectable_collection',
            as: :collectable_collection
