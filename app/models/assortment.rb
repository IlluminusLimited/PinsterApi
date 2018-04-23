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
  has_many :images, as: :imageable, dependent: :destroy

  has_many :pin_assortments, dependent: :destroy
end
