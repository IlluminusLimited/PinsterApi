# == Schema Information
#
# Table name: tags
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name)
#

class Tag < ApplicationRecord
  has_many :tag_categories, dependent: :destroy
  has_many :tagged_taggables, dependent: :destroy

  has_many :taggables, through: :tagged_taggables
  has_many :categories, through: :tag_categories

  before_save {|tag| tag.name = tag.name.downcase}

  validates :name, presence: true
  validates :name, uniqueness: true
end
