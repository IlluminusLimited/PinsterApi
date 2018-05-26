# frozen_string_literal: true
# == Schema Information
#
# Table name: assortments
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_assortments_on_created_at  (created_at)
#

require 'test_helper'

class AssortmentTest < ActiveSupport::TestCase
  test 'assortmets are sorted by created at :desc' do
    assert_equal Assortment.order(created_at: :desc).to_sql, Assortment.recently_added.all.to_sql
  end
end
