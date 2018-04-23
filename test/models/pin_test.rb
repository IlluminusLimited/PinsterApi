# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  year        :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # test pins can be created and whatnot
end
