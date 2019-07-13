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

      get v1_search_url(query: 'ohio', published: 'all'), as: :json
      assert_response :success
      pin = pins(:ohio_cow)
      assert_no_match(pin.id, response.body)
    end

    def test_pin_search_can_use_partial_words
      get v1_search_pins_url(query: 'time'), as: :json
      assert_response :success
      results = JSON.parse(response.body)['data']

      assert_equal 1, results.size,
                   "One pin should be present since this query requires published only"
    end

    def test_pin_search_can_use_whole_words
      get v1_search_pins_url(query: 'classic'), as: :json
      assert_response :success

      results = JSON.parse(response.body)['data']

      assert_equal 1, results.size, "Only one pin should be returned"
      assert_equal pins(:massachusetts_crab).id, results.first['id']
    end

    def test_pin_search_ranks_results
      get v1_search_pins_url(query: 'unicorn was made up'), as: :json

      assert_response :success
      results = JSON.parse(response.body)['data']

      assert_equal 2, results.size, "Time should match two pins"
      assert_equal pins(:wisconsin_unicorn).id, results.first['id'],
                   "Wisconsin unicorn should be first since 'unicorn was made up' is a direct match"
      assert_equal pins(:wisconsin_gargoyle).id, results.second['id'],
                   "Wisconsin gargoyle should be second since 'was made up' matches"
    end
  end
end
