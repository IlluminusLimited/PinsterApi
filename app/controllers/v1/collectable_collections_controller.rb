# frozen_string_literal: true

module V1
  class CollectableCollectionsController < ApplicationController
    before_action :require_login
    before_action :set_collectable_collection, only: %i[show update destroy]
    after_action :verify_authorized

    api :GET, '/v1/collections/:collection_id/collectable_collections',
        "Show a collection's collectable_collections"
    param :collection_id, String, allow_nil: false, required: true
    # param :images, :bool, default: true, required: false
    # param :page, Hash, required: false do
    #   param :size, String, default: 10
    # end

    def index
      @collectable_collections = CollectableCollection.all
      authorize @collectable_collections
      render :index
    end

    api :GET, '/v1/collectable_collections/:id', 'Show a collectable_collection'
    param :id, String, allow_nil: false, required: true
    error :forbidden, 'You are not authorized to perform this action'
    error :unauthorized, 'Request missing Authorization header'

    def show
      authorize @collectable_collection
      render :show
    end

    api :POST, '/v1/collections/:collection_id/collectable_collections',
        'Create a new collectable_collection'
    param :collection_id, String, allow_nil: false, required: true
    error :unauthorized, 'Request missing Authorization header'

    def create
      @collectable_collection = CollectableCollection.new(collectable_collection_params)
      authorize @collectable_collection

      if @collectable_collection.save
        render :show, status: :created, location: v1_collectable_collection_url(@collectable_collection)
      else
        render json: @collectable_collection.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/collectable_collections/:id',
        'Update a collectable_collection'
    api :PUT, '/v1/collectable_collections/:id',
        'Update a collectable_collection'
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def update
      authorize @collectable_collection

      if @collectable_collection.update(collectable_collection_params)
        render :show, status: :ok, location: v1_collectable_collection_url(@collectable_collection)
      else
        render json: @collectable_collection.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/v1/collectable_collections/:id', 'Destroy a collectable_collection'
    param :id, String, allow_nil: false, required: true
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      collectable_collection = CollectableCollection.find(params[:id])
      authorize collectable_collection
      collectable_collection.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_collectable_collection
        @collectable_collection = CollectableCollection.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def collectable_collection_params
        params.require(:data).permit(CollectableCollection.public_attribute_names)
      end
  end
end
