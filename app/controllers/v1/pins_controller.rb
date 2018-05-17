# frozen_string_literal: true

module V1
  class PinsController < ApplicationController
    before_action :set_pin, only: %i[show update destroy]
    after_action :verify_authorized, except: %i[index show]

    api :GET, '/v1/pins', 'List pins'
    def index
      @filterrific = initialize_filterrific(
        Pin,
        params,
        persistence_id: false,
        available_filters: %i[with_name with_description with_tag with_year search_query sorted_by]
      ) or return

      @pins = @filterrific.find.with_images

      render :index
    end

    api :GET, '/v1/pins/:id', 'Show a pin'
    param :id, String, allow_nil: false
    def show; end

    api :POST, '/v1/pins', 'Create a pin'
    def create
      @pin = Pin.new(pin_params)
      authorize @pin

      if @pin.save
        render :show, status: :created, location: v1_pin_url(@pin)
      else
        render json: @pin.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/pins/:id', 'Update a pin'
    api :PUT, '/v1/pins/:id', 'Update a pin'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    def update
      authorize @pin

      if @pin.update(pin_params)
        render :show, status: :ok, location: v1_pin_url(@pin)
      else
        render json: @pin.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, 'v1/pins/:id', 'Destroy a pin'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    def destroy
      authorize @pin
      @pin.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_pin
        @pin = Pin.includes(:images).find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def pin_params
        params.require(:data).permit(:name, :year, :description)
      end
  end
end
