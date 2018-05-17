# frozen_string_literal: true

json.links do
  json.pages! @pins, url: v1_pins_url, query_parameters: params[:all_images]
end

json.data do
  json.array! @pins, partial: 'v1/pins/pin', as: :pin
end
