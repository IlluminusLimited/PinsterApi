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
  has_many :images, as: :imageable, dependent: :destroy

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_one :pin_assortment, dependent: :destroy

  validates :name, presence: true
end
