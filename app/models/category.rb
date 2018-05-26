# == Schema Information
#
# Table name: categories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

class Category < ApplicationRecord
  has_many :tag_categories, dependent: :destroy
  has_many :tags, through: :tag_categories

  validates :name, presence: true
  validates :name, uniqueness: true
end
