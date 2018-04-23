# frozen_string_literal: true

module V1
  class PinsController < ApplicationController
    before_action :set_pin, only: %i[show update destroy]

    # GET /pins
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/pins', 'List pins'
    param :null, Object, allow_nil: true
    def index
      @pins = Pin.all

      render json: @pins
    end

    # GET /pins/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/pins/:id', 'Show a pin'
    param :null, Object, allow_nil: true
    def show
      render json: @pin
    end

    # POST /pins
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :POST, '/v1/pins', 'Create a pin'
    def create
      @pin = Pin.new(pin_params)

      if @pin.save
        render :show, status: :created, location: v1_pin_url(@pin)
      else
        render json: @pin.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /pins/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :PATCH, '/v1/pins/:id', 'Update a pin'
    api :PUT, '/v1/pins/:id', 'Update a pin'
    def update
      if @pin.update(pin_params)
        render :show, status: :ok, location: v1_pin_url(@pin)
      else
        render json: @pin.errors, status: :unprocessable_entity
      end
    end

    # DELETE /pins/1
    def destroy
      @pin.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_pin
        @pin = Pin.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def pin_params
        params.require(:data).permit(:name, :year, :description)
      end
  end
end
