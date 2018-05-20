# frozen_string_literal: true

json.links do
  json.pages! @assortments, url: v1_assortments_url, query_parameters: { images: params[:images] }
end

json.data do
  json.array! @assortments, partial: 'v1/assortments/assortment', as: :assortment
end
