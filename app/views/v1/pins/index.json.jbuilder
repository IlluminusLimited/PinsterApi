# frozen_string_literal: true

json.array! @pins, partial: 'v1/pins/pin', as: :pin
