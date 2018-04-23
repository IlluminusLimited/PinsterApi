# frozen_string_literal: true

# == Schema Information
#
# Table name: collections
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_collections_on_user_id  (user_id)
#

class Collection < ApplicationRecord
  has_many :images, as: :imageable, dependent: :destroy

  has_many :collectable_collections, dependent: :destroy

  belongs_to :user

  validates :id, presence: true
  validates :name, presence: true
  validates :user, presence: true
end
