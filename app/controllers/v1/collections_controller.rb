# frozen_string_literal: true

module V1
  class CollectionsController < ApplicationController
    before_action :require_login, except: %i[show]
    before_action :set_collection, only: %i[show update destroy]
    after_action :verify_authorized, except: %i[index]

    api :GET, '/v1/users/:user_id/collections', "Show a user's collections"
    param :user_id, String, allow_nil: false
    def index
      @collections = policy_scope(Collection)

      render json: @collections
    end

    api :GET, '/v1/collections/:id', 'Show a collection'
    param :id, String, allow_nil: false
    error :forbidden, 'You are not authorized to perform this action'
    def show
      authorize @collection, :show?
      render json: @collection
    end

    api :POST, '/v1/users/:user_id/collections', 'Create a collection'
    param :user_id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    def create
      @collection = Collection.new(collection_params)
      authorize @collection

      if @collection.save
        render json: @user, status: :created
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/collections/:id', 'Update a collection'
    api :PUT, '/v1/collections/:id', 'Update a collection'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
    def update
      authorize @collection

      if @collection.update(collection_params)
        render json: @collection
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, 'v1/collections/:id', 'Destroy a collection'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'
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
