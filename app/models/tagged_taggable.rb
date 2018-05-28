# == Schema Information
#
# Table name: tagged_taggables
#
#  id            :uuid             not null, primary key
#  taggable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_id        :uuid
#  taggable_id   :uuid
#
# Indexes
#
#  index_tagged_taggables_on_tag_id                         (tag_id)
#  index_tagged_taggables_on_taggable_type_and_taggable_id  (taggable_type,taggable_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#

class TaggedTaggable < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
