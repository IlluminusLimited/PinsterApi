# frozen_string_literal: true

require 'test_helper'
require 'jbuilder/pagination'

class PaginationTest < ActiveSupport::TestCase
  include Pagination
  test 'pagination calls pagination methods' do
    call_count = 0
    test_pagers = [[:page, ->(_params) { call_count += 1 }], [:per, ->(_params) { call_count += 1 }]]
    paginate(Pin.all, test_pagers, page: { size: 2 })
    assert_equal 2, call_count, 'The lambdas in the pagination methods array should be called'
  end

  test 'pagination raises error on unpageable resource' do
    test_pagers = [[:page, ->(params) { params }]]
    assert_raises(Pagination::Errors::UnpageableResourceError) do
      paginate({ not: :pageable }, test_pagers, page: { size: 2 })
    end
  end
end
