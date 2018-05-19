# frozen_string_literal: true

require 'test_helper'
module V1
  class SearchControllerTest < ActionDispatch::IntegrationTest
    test 'search returns results' do
      PgSearch::Multisearch.rebuild(Pin, true)
      PgSearch::Multisearch.rebuild(Assortment, true)

      get v1_search_url(query: 'Wisconsin'), as: :json
      assert_response :success

      assert_match('Wisconsin Unicorn', response.body)
    end
  end
end
