# frozen_string_literal: true

module V1
  class ImagesController < ApplicationController
    before_action :set_image, only: %i[show update destroy]
    after_action :verify_authorized, except: %i[show index]

    api :GET, '/v1/:imageable_type/:imageable_id/images', "Show an imageable's images"
    param :imageable_type, String, allow_nil: false, required: true
    param :imageable_id, String, allow_nil: false

    def index
      imageable_key = params.keys.select { |key| /\w+_id/.match(key.to_s) }.compact.first
      @images = Image.where(imageable_type: params[:imageable_type], imageable_id: params[imageable_key.to_sym])
      render :index
    end

    api :GET, '/v1/images/:id', 'Show an image'
    param :id, String, allow_nil: false, required: true

    def show; end

    api :POST, '/v1/images', 'Create an image'
    api :POST, '/v1/:imageable_type/:imageable_id/images', 'Create an image'
    param :imageable_type, String, required: false
    param :imageable_id, String, required: false

    param :data, Hash, required: true do
      param :imageable_type, String, required: false
      param :imageable_id, String, required: false
      param :base_file_name, String, required: true
      param :storage_location_uri, String, required: true
      param :featured, String, required: false
      param :name, String, required: false
      param :description, String, required: false
    end

    def create
      # if the the token is from image service, return 201 ok.
      # If the token is from a user, return 202 accepted.
      all_params = image_params.dup
      all_params[:imageable_type] ||= params[:imageable_type]
      all_params[:imageable_id] ||= params[(all_params[:imageable_type].to_s.downcase + "_id").to_sym]

      @image = Image.new(all_params)
      authorize @image

      if @image.save
        render :show, status: :created, location: v1_image_url(@image)
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/images/:id', 'Update an image'
    api :PUT, '/v1/images/:id', 'Update an image'
    param :id, String, allow_nil: false, required: true
    param :data, Hash, required: true do
      param :name, String, required: false
      param :featured, String, required: false
      param :description, String, required: false
    end
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

    api :DELETE, 'v1/images/:id', 'Destroy an image'
    param :id, String, allow_nil: false, required: true
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      authorize @image
      @image.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_image
        @image = Image.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def image_params
        # if current_user.can?('create:image')
        params.require(:data).permit([Image.public_attribute_names, :encoded].flatten)
      end
  end
end
