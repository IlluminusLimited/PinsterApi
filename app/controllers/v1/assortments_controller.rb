# frozen_string_literal: true

module V1
  class AssortmentsController < ApplicationController
    before_action :require_login, except: %i[show index]
    before_action :set_assortment, only: %i[update destroy]
    before_action :set_assortment_with_images, only: %i[show]
    after_action :verify_authorized, except: %i[index show]

    api :GET, '/v1/assortments', 'List assortments'
    param :images, :bool, default: true, required: false

    def index
      @assortments = paginate Assortment.build_query(params)
      render :index
    end

    api :GET, '/v1/assortments/:id', 'Show an assortment'
    param :with_collections, :bool, default: false, required: false
    param :id, String, allow_nil: false, required: true

    def show
      if params[:with_collectable_collections].to_s == 'true'
        @collectable_collections = CollectableCollection.where(collectable: @assortment)
                                                        .joins(:collection)
                                                        .where('collections.user_id = ?', current_user.id)
      end

      authorize @assortment
      render :show
    end

    api :POST, '/v1/assortments', 'Create an assortment'
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    error :unprocessable_entity, 'Validation error. Check the body for more info.'

    def create
      @assortment = Assortment.new(assortment_params)
      authorize @assortment

      if @assortment.save
        render :show, status: :created, location: v1_assortment_url(@assortment)
      else
        render json: @assortment.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/assortments/:id', 'Update an assortment'
    api :PUT, '/v1/assortments/:id', 'Update an assortment'
    param :id, String, allow_nil: false, required: true
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    error :unprocessable_entity, 'Validation error. Check the body for more info.'

    def update
      authorize @assortment

      if @assortment.update(assortment_params)
        render :show, status: :ok, location: v1_assortment_url(@assortment)
      else
        render json: @assortment.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/v1/assortments/:id', 'Destroy an assortment'
    param :id, String, allow_nil: false, required: true
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      authorize @assortment

      @assortment.destroy
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      nil
    end

    private

      def set_assortment
        @assortment = Assortment.find(params[:id])
      end

      def set_assortment_with_images
        @assortment = Assortment.with_images.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def assortment_params
        params.require(:data).permit(:name, :description, :tags)
      end
  end
end
