# frozen_string_literal: true

module V1
  class PinsController < ApplicationController
    before_action :require_login, except: %i[show index]
    before_action :set_paper_trail_whodunnit, only: %i[create update]
    after_action :verify_authorized, except: %i[index show]

    api :GET, '/v1/pins', 'List pins'
    param :images, :bool, default: true, required: false
    param :published, %w[true false all], default: true, required: false, desc: "Token must have publish:pin"
    param :page, Hash, required: false do
      param :size, String, default: 25
    end

    def index
      @pins = paginate(PinPolicy::Scope.new(
        current_user,
        params[:published],
        Pin.build_query(params)
      ).resolve)

      render :index
    end

    api :GET, '/v1/pins/:id', 'Show a pin'
    param :id, String, allow_nil: false, required: true
    param :with_collectable_collections, :bool, default: false, required: false
    param :all_images, :bool, default: false, required: false
    param :published, %w[true false all], default: true, required: false, desc: "Token must have publish:pin"

    def show
      @pin = PinPolicy::Scope.new(current_user,
                                  params[:published],
                                  Pin.build_query(params))
                             .resolve
                             .find(params[:id])
      if params[:with_collectable_collections].to_s == 'true'
        @collectable_collections = CollectableCollection.where(collectable: @pin)
                                                        .joins(:collection)
                                                        .where('collections.user_id = ?', current_user.id) || []
      elsif params[:all_images]
        @images = @pin.all_images if params[:all_images]
      end
      authorize @pin
      render :show
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      render json: { errors: "Not Found" }, status: :not_found
    end

    api :POST, '/v1/pins', 'Create a pin'
    param :data, Hash do
      param :name, String, required: true
      param :description, String, required: false
      param :year, Integer, required: false
    end
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    error :unprocessable_entity, 'Validation error. Check the body for more info.'

    def create
      @pin = Pin.new(permitted_attributes(Pin.new))
      authorize @pin

      if @pin.save
        render :show, status: :created, location: v1_pin_url(@pin)
      else
        render json: @pin.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/pins/:id', 'Update a pin'
    api :PUT, '/v1/pins/:id', 'Update a pin'
    param :id, String, allow_nil: false, required: true
    param :data, Hash do
      param :name, String, required: false
      param :description, String, required: false
      param :year, Integer, required: false
    end
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    error :unprocessable_entity, 'Validation error. Check the body for more info.'

    def update
      @pin = PinPolicy::Scope.new(current_user, 'all', Pin)
                             .resolve
                             .find(params[:id])
      authorize @pin

      if @pin.update(permitted_attributes(@pin))
        render :show, status: :ok, location: v1_pin_url(@pin)
      else
        render json: @pin.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      render json: { errors: "Not Found" }, status: :not_found
    end

    api :DELETE, 'v1/pins/:id', 'Destroy a pin'
    param :id, String, allow_nil: false, required: true
    param :published, %w[true false all], default: true, required: false, desc: "Token must have publish:pin"
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      @pin = PinPolicy::Scope.new(current_user, params[:published], Pin)
                             .resolve
                             .find(params[:id])
      authorize @pin
      @pin.destroy
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      nil
    end
  end
end
