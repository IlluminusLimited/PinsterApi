# frozen_string_literal: true

module V1
  class AssortmentsController < ApplicationController
    before_action :set_assortment, only: %i[show update destroy]

    api :GET, '/v1/assortments', 'List assortments'
    def index
      @assortments = Assortment.all

      render json: @assortments
    end

    api :GET, '/v1/assortments/:id', 'Show an assortment'
    param :id, String, requred: true
    def show
      render json: @assortment
    end

    api :POST, '/v1/assortments', 'Create an assortment'
    def create
      @assortment = Assortment.new(assortment_params)

      if @assortment.save
        render show: @assortment, status: :created, location: v1_assortment_url(@assortment)
      else
        render json: @assortment.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/assortments/:id', 'Update an assortment'
    api :PUT, '/v1/assortments/:id', 'Update an assortment'
    def update
      if @assortment.update(assortment_params)
        render show: @assortment, status: :ok, location: v1_assortment_url(@assortment)
      else
        render json: @assortment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /assortments/1
    def destroy
      @assortment.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_assortment
        @assortment = Assortment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def assortment_params
        params.require(:data).permit(:name, :description)
      end
  end
end
