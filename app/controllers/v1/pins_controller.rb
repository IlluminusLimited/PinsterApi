# frozen_string_literal: true

module V1
  class PinsController < ApplicationController
    before_action :set_pin, only: %i[show update]
    after_action :verify_authorized, except: %i[index show]

    api :GET, '/v1/pins', 'List pins'
    param :images, :bool, default: true, required: false

    def index
      @pins = paginate Pin.build_query(params)

      render :index
    end

    api :GET, '/v1/pins/:id', 'Show a pin'
    param :id, String, allow_nil: false
    param :with_collectable_collections, :bool, default: false, required: false
    param :all_images, :bool, default: false, required: false

    def show
      if params[:with_collectable_collections].to_s == 'true'
        @collectable_collections = CollectableCollection.where(collectable: @pin)
                                                        .joins(:collection)
                                                        .where('collections.user_id = ?', current_user.id)
      elsif params[:all_images]
        @images = @pin.all_images if params[:all_images]
      end
      authorize @pin
      render :show
    end

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
      pin = Pin.find(params[:id])
      authorize pin
      pin.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_pin
        @pin = Pin.build_query(params).find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def pin_params
        params.require(:data).permit(:name, :year, :description, :tags)
      end
  end
end
