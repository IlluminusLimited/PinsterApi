# frozen_string_literal: true

# frozen_string_literal: true

json.links do
  json.pages! @pins, url: v1_pins_url
end

json.data do
  json.array! @pins, partial: 'v1/pins/pin', as: :pin
end
