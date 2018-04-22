# frozen_string_literal: true

class CollectableCollectionsController < ApplicationController
  before_action :set_collectable_collection, only: %i[show update destroy]

  # GET /collectable_collections
  def index
    @collectable_collections = CollectableCollection.all

    render json: @collectable_collections
  end

  # GET /collectable_collections/1
  def show
    render json: @collectable_collection
  end

  # POST /collectable_collections
  def create
    @collectable_collection = CollectableCollection.new(collectable_collection_params)

    if @collectable_collection.save
      render json: @collectable_collection, status: :created, location: @collectable_collection
    else
      render json: @collectable_collection.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /collectable_collections/1
  def update
    if @collectable_collection.update(collectable_collection_params)
      render json: @collectable_collection
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
      params.require(:collectable_collection).permit(:collectable_type, :collectable_id, :collection_id)
    end
end
