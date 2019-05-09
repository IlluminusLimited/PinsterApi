# frozen_string_literal: true

json.links do
  json.pages! @search, url: request.original_url, query_parameters: params[:all_images]
end

json.data do
  json.array! @search, partial: 'v1/searches/search', as: :search
end
