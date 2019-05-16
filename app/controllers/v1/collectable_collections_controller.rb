# frozen_string_literal: true

module V1
  class CollectableCollectionsController < ApplicationController
    before_action :require_login
    before_action :set_collection, only: [:index]
    before_action :set_collectable_collection, only: %i[show update]
    after_action :verify_authorized

    api :GET, '/v1/collections/:collection_id/collectable_collections', "Show a collection's collectable_collections"
    param :collection_id, String, allow_nil: false, required: true
    param :page, Hash, required: false do
      param :size, String, default: 25
    end

    def index
      authorize @collection, :show?
      @collectable_collections = paginate(@collection.collectable_collections)
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

    api :POST, '/v1/collections/:collection_id/collectable_collections', 'Create a new collectable_collection'
    param :collection_id, String, allow_nil: false, required: true
    error :forbidden, 'You are not authorized to perform this action'
    error :unauthorized, 'Request missing Authorization header'
    error :unprocessable_entity, 'Validation error. Check the body for more info.'

    def create
      @collectable_collection = CollectableCollection.new({ collection_id: params[:collection_id] }
                                                              .merge(permitted_attributes(CollectableCollection.new)))
      authorize @collectable_collection

      if @collectable_collection.save
        render :show, status: :created, location: v1_collectable_collection_url(@collectable_collection)
      else
        render json: @collectable_collection.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/collectable_collections/:id', 'Update a collectable_collection'
    api :PUT, '/v1/collectable_collections/:id', 'Update a collectable_collection'
    param :id, String, allow_nil: false, required: true
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    error :unprocessable_entity, 'Validation error. Check the body for more info.'

    def update
      authorize @collectable_collection

      if @collectable_collection.update(permitted_attributes(@collectable_collection))
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
        @collectable_collection = CollectableCollection.includes(:collection).find(params[:id])
      end

      def set_collection
        @collection = Collection.includes(collectable_collections: [:collectable]).find(params[:collection_id])
      end
  end
end
