# frozen_string_literal: true

module V1
  class ImagesController < ApplicationController
    include Behaveable::ResourceFinder
    include Behaveable::RouteExtractor

    before_action :require_login, except: %i[index show]
    before_action :set_image, only: %i[show update destroy]
    after_action :verify_authorized, except: %i[index]

    api :GET, '/v1/assortments/:assortment_id/images', "Show an assortment's images"
    api :GET, '/v1/collections/:collection_id/images', "Show a collection's images"
    api :GET, '/v1/pins/:pin_id/images', "Show a pin's images"
    api :GET, '/v1/users/:user_id/images', "Show a user's images"
    param :assortment_id, String, allow_nil: true, default: ''
    param :collection_id, String, allow_nil: true, default: ''
    param :pin_id, String, allow_nil: true, default: ''
    param :user_id, String, allow_nil: true, default: ''

    def index
      @images = imageable.all
      authorize @images
      render :index
    end

    api :GET, '/v1/images/:id', 'Show an image'
    param :id, String, allow_nil: false

    def show
      render :show
    end

    api :POST, '/v1/assortments/:assortment_id/images', "Create an image for an assortment"
    api :POST, '/v1/collections/:collection_id/images', "Create an image for a collection"
    api :POST, '/v1/pins/:pin_id/images', "Create an image for a pin"
    api :POST, '/v1/users/:user_id/images', "Create an image for a user"
    param :assortment_id, String, allow_nil: true, default: ''
    param :collection_id, String, allow_nil: true, default: ''
    param :pin_id, String, allow_nil: true, default: ''
    param :user_id, String, allow_nil: true, default: ''
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def create
      @image = Image.new(image_params)
      authorize @image

      if @image.save
        render :show, status: :created, location: v1_image_url(@image)
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/images/:id', 'Update an image'
    api :PUT, '/v1/images/:id', 'Update an image'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def update
      authorize @image

      if @image.update(image_params)
        render :show, status: :ok, location: v1_image_url(@image)
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/v1/images/:id', 'Destroy an image'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      authorize @image
      @image.destroy
    end

    private

      def imageable
        @behaveable ||= behaveable
        @behaveable ? @behaveable.images : Image
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_image
        @image = Image.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def image_params
        image = @image || Image.new
        params.require(:data).permit(policy(image).permitted_attributes)
      end
  end
end
