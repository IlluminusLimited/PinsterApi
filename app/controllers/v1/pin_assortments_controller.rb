# frozen_string_literal: true

module V1
  class PinAssortmentsController < ApplicationController
    before_action :set_pin_assortment, only: %i[show update destroy]

    # GET /pin_assortments
    def index
      @pin_assortments = PinAssortment.all

      render json: @pin_assortments
    end

    # GET /pin_assortments/1
    def show
      render json: @pin_assortment
    end

    # POST /pin_assortments
    def create
      @pin_assortment = PinAssortment.new(pin_assortment_params)

      if @pin_assortment.save
        render show: @pin_assortment, status: :created, location: v1_pin_assortment_url(@pin_assortment)
      else
        render json: @pin_assortment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /pin_assortments/1
    def update
      if @pin_assortment.update(pin_assortment_params)
        render :show, status: :ok, location: v1_pin_assortment_url(@pin_assortment)
      else
        render json: @pin_assortment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /pin_assortments/1
    def destroy
      @pin_assortment.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_pin_assortment
        @pin_assortment = PinAssortment.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def pin_assortment_params
        params.require(:data).permit(:pin_id, :assortment_id)
      end
  end
end
