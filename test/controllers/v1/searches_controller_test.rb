# frozen_string_literal: true

require 'test_helper'
module V1
  class SearchesControllerTest < ActionDispatch::IntegrationTest
    test 'searches returns results' do
      PgSearch::Multisearch.rebuild(Pin, true)
      PgSearch::Multisearch.rebuild(Assortment, true)

      get v1_search_url(query: 'Wisconsin'), as: :json
      assert_response :success

      assert_match('Wisconsin Unicorn', response.body)
      assert_match('url', response.body)
      assert_match '2009', response.body
    end

    test 'searches can search by year results' do
      PgSearch::Multisearch.rebuild(Pin, true)
      PgSearch::Multisearch.rebuild(Assortment, true)

      get v1_search_url(query: '1999'), as: :json
      assert_response :success

      assert_match('Massachusetts', response.body)
      assert_match('url', response.body)
    end

    test 'searches exclude unpublished by default' do
      PgSearch::Multisearch.rebuild(Pin, true)
      PgSearch::Multisearch.rebuild(Assortment, true)

      get v1_search_url(query: 'ohio'), as: :json
      assert_response :success
      pin = pins(:ohio_cow)
      assert_no_match(pin.id, response.body)
    end
  end
end
