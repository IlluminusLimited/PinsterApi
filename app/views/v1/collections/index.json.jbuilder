# frozen_string_literal: true

json.array! @collections, partial: 'v1/collections/collection', as: :collection
