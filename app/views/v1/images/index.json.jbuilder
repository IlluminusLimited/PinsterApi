# frozen_string_literal: true

json.array! @images, partial: 'v1/images/image', as: :image
