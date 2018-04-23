# frozen_string_literal: true

module V1
  class CollectableCollectionsController < ApplicationController
    before_action :set_collectable_collection, only: %i[show update destroy]

    # GET /collectable_collections
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/collectable_collections', 'List collectable collections'
    param :null, Object, allow_nil: true
    def index
      @collectable_collections = CollectableCollection.all

      render json: @collectable_collections
    end

    # GET /collectable_collections/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/collectable_collections/:id', 'Show a collectable collection'
    param :null, Object, allow_nil: true
    def show
      render json: @collectable_collection
    end

    # POST /collectable_collections
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :POST, '/v1/collectable_collections', 'Create a collectable collection'
    def create
      @collectable_collection = CollectableCollection.new(collectable_collection_params)

      if @collectable_collection.save
        render show: @collectable_collection, status: :created,
               location: v1_collectable_collection_url(@collectable_collection)
      else
        render json: @collectable_collection.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /collectable_collections/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :PATCH, '/v1/collectable_collections/:id', 'Update a collectable collection'
    api :PUT, '/v1/collectable_collections/:id', 'Update a collectable collection'
    def update
      if @collectable_collection.update(collectable_collection_params)
        render show: @collectable_collection, status: :ok,
               location: v1_collectable_collection_url(@collectable_collection)
      else
        render json: @collectable_collection.errors, status: :unprocessable_entity
      end
    end

    # DELETE /collectable_collections/1
    def destroy
      @collectable_collection.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_collectable_collection
        @collectable_collection = CollectableCollection.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def collectable_collection_params
        params.require(:data).permit(:collectable_type, :collectable_id, :collection_id)
      end
  end
end
