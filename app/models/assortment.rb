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

  has_many :collectable_collections, as: :collectable, dependent: :destroy
  has_many :collections, through: :collectable_collections
  has_many :pin_assortments, dependent: :destroy

  accepts_nested_attributes_for :collectable_collections
  accepts_nested_attributes_for :pin_assortments

  def to_s
    "Assortment(Set): '#{id}:#{name}'"
  end
end
