# frozen_string_literal: true

# == Schema Information
#
# Table name: assortments
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  tags        :jsonb            not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class AssortmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # test assortment members respond to images method and return an array of images
end
