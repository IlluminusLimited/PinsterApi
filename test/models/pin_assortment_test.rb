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
#

require 'test_helper'

class PinAssortmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
