# frozen_string_literal: true
# == Schema Information
#
# Table name: assortments
#
#  id           :uuid             not null, primary key
#  description  :text
#  images_count :integer          default(0), not null
#  name         :string
#  tags         :jsonb            not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_assortments_on_created_at    (created_at)
#  index_assortments_on_images_count  (images_count)
#

require 'test_helper'

class AssortmentTest < ActiveSupport::TestCase
  test 'assortmets are sorted by created at :desc' do
    assert_equal Assortment.order(created_at: :desc).to_sql, Assortment.recently_added.all.to_sql
  end
end
