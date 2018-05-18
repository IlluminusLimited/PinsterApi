# frozen_string_literal: true

json.links do
  json.pages! @collections, url: request.original_url, query_parameters: { images: params[:images] }
end

json.data do
  json.array! @collections, partial: 'v1/collections/collection', as: :collection
end
