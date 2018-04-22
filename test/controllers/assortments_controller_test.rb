# frozen_string_literal: true

require 'test_helper'

class AssortmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assortment = assortments(:one)
  end

  test 'should get index' do
    get assortments_url, as: :json
    assert_response :success
  end

  test 'should create assortment' do
    assert_difference('Assortment.count') do
      post assortments_url, params: { assortment: { description: @assortment.description, name: @assortment.name } }, as: :json
    end

    assert_response 201
  end

  test 'should show assortment' do
    get assortment_url(@assortment), as: :json
    assert_response :success
  end

  test 'should update assortment' do
    patch assortment_url(@assortment), params: { assortment: { description: @assortment.description, name: @assortment.name } }, as: :json
    assert_response 200
  end

  test 'should destroy assortment' do
    assert_difference('Assortment.count', -1) do
      delete assortment_url(@assortment), as: :json
    end

    assert_response 204
  end
end
