# frozen_string_literal: true

module V1
  class CollectionsController < ApplicationController
    before_action :set_collection, only: %i[show update destroy]

    # GET /collections
    def index
      @collections = Collection.all

      render json: @collections
    end

    # GET /collections/1
    def show
      render json: @collection
    end

    # POST /collections
    def create
      @collection = Collection.new(collection_params)

      if @collection.save
        render show: @collection, status: :created, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /collections/1
    def update
      if @collection.update(collection_params)
        render show: @collection, status: :ok, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    # DELETE /collections/1
    def destroy
      @collection.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_collection
        @collection = Collection.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def collection_params
        params.require(:data).permit(:user_id,
                                     :name,
                                     :description,
                                     collectable_collections_attributes: CollectableCollection.attribute_names
                                                                             .map(&:to_sym))
      end
  end
end
