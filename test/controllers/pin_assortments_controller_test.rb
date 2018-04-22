# frozen_string_literal: true

require 'test_helper'

class PinAssortmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pin_assortment = pin_assortments(:one)
  end

  test 'should get index' do
    get pin_assortments_url, as: :json
    assert_response :success
  end

  test 'should create pin_assortment' do
    assert_difference('PinAssortment.count') do
      post pin_assortments_url, params: { pin_assortment: { assortment_id: @pin_assortment.assortment_id, pin_id: @pin_assortment.pin_id } }, as: :json
    end

    assert_response 201
  end

  test 'should show pin_assortment' do
    get pin_assortment_url(@pin_assortment), as: :json
    assert_response :success
  end

  test 'should update pin_assortment' do
    patch pin_assortment_url(@pin_assortment), params: { pin_assortment: { assortment_id: @pin_assortment.assortment_id, pin_id: @pin_assortment.pin_id } }, as: :json
    assert_response 200
  end

  test 'should destroy pin_assortment' do
    assert_difference('PinAssortment.count', -1) do
      delete pin_assortment_url(@pin_assortment), as: :json
    end

    assert_response 204
  end
end
