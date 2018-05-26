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

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
