# frozen_string_literal: true

json.links do
  json.pages! @search, url: v1_search_url, query_parameters: params[:all_images]
end

json.data do
  json.array! @search, partial: 'v1/searches/search', as: :search
end
