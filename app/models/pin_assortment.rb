# frozen_string_literal: true

# == Schema Information
#
# Table name: pin_assortments
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assortment_id :uuid
#  pin_id        :uuid
#
# Indexes
#
#  index_pin_assortments_on_assortment_id  (assortment_id)
#  index_pin_assortments_on_pin_id         (pin_id) UNIQUE
#

class PinAssortment < ApplicationRecord
  belongs_to :pin
  belongs_to :assortment
end
