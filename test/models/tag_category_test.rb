# == Schema Information
#
# Table name: tag_categories
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :uuid
#  tag_id      :uuid
#
# Indexes
#
#  index_tag_categories_on_category_id_and_tag_id  (category_id,tag_id) UNIQUE
#

require 'test_helper'

class TagCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
