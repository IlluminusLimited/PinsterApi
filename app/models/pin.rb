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

class Pin < ApplicationRecord
  has_many :images, as: :imageable, dependent: :destroy, inverse_of: :pin

  has_many :collectable_collections
  has_one :pin_assortment
end
