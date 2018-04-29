# frozen_string_literal: true

module V1
  class CollectionsController < ApplicationController
    before_action :set_collection, only: %i[show update destroy]

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/users/:user_id/collections', 'Create a collection'
    param :user_id, String, allow_nil: false
    def index
      @collections = policy_scope(Collection)

      render json: @collections
    end

    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/collections/:id', 'Show a collection'
    param :id, String, allow_nil: false
    def show
      authorize @collection, :show?
      render json: @collection
    end

    # POST /collections
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :POST, '/v1/users/:user_id/collections', 'Create a collection'
    param :user_id, String, allow_nil: false
    def create
      @collection = Collection.new(collection_params)
      authorize @collection

      if @collection.save
        render show: @collection, status: :created, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /collections/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :PATCH, '/v1/collections/:id', 'Update a collection'
    api :PUT, '/v1/collections/:id', 'Update a collection'
    param :id, String, allow_nil: false
    def update
      authorize @collection

      if @collection.update(collection_params)
        render show: @collection, status: :ok, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    # DELETE /collections/1
    def destroy
      authorize @collection
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
                                     :public,
                                     collectable_collections_attributes: CollectableCollection.attribute_names
                                                                             .map(&:to_sym))
      end
  end
end
