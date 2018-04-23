# frozen_string_literal: true

json.array! @assortments, partial: 'v1/assortments/assortment', as: :assortment
