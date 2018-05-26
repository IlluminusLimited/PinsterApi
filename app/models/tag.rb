# == Schema Information
#
# Table name: tags
#
#  id            :uuid             not null, primary key
#  name          :string
#  taggable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  taggable_id   :uuid
#
# Indexes
#
#  index_tags_on_name                           (name) UNIQUE
#  index_tags_on_taggable_type_and_taggable_id  (taggable_type,taggable_id)
#

class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true

  has_many :tag_categories, dependent: :destroy

  has_many :categories, through: :tag_categories

  before_save {|tag| tag.name  = tag.name.downcase}

  validates :name, presence: true
  validates :name, uniqueness: true
end
