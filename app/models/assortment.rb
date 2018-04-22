# frozen_string_literal: true

# == Schema Information
#
# Table name: assortments
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Assortment < ApplicationRecord
end
