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

    api :POST, '/v1/images', 'Create request to upload an image (Or actually create an image if you are ImageService)'
    api :POST, '/v1/:imageable_type/:imageable_id/images', 'Create request to upload an image'
    param :imageable_type, String, required: false
    param :imageable_id, String, required: false

    param :data, Hash, required: true do
      param :imageable_type, String, required: false
      param :imageable_id, String, required: false
      param :base_file_name, String, required: false, desc: 'Image service use only'
      param :storage_location_uri, String, required: false, desc: 'Image service use only'
      param :featured, String, required: false
      param :name, String, required: false
      param :description, String, required: false
    end

    def create
      # if the the token is from image service, return 201 created.
      # If the token is from a user, return 202 accepted.
      return image_service_create if current_user.service?

      all_params = add_imageable_from_params(image_params)
      @image = Image.new(all_params)
      authorize @image

      @image_service_token = token_generator.generate_jwt(extract_imageable(@image.imageable))

      render 'v1/images/accepted_show', status: :accepted
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

    def self.__token_generator_producer=(token_generator_producer)
      @@token_generator_producer ||= token_generator_producer
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_image
        @image = Image.find(params[:id])
      end

      # Used to figure out what the imageable type is since rails names the id after the imageable type
      def add_imageable_from_params(base_params)
        all_params = base_params.dup
        all_params[:imageable_type] ||= params[:imageable_type]
        all_params[:imageable_id] ||= params[(all_params[:imageable_type].to_s.downcase + "_id").to_sym]
        all_params
      end

      # Only allow a trusted parameter "white list" through.
      def image_params
        params.require(:data).permit(Image.public_attribute_names)
      end

      def restricted_image_params
        params.require(:data).permit(Image.all_attribute_names)
      end

      def extract_imageable(imageable)
        { imageable_type: imageable.class.to_s, imageable_id: imageable.id, user_id: current_user.id }
      end

      def image_service_create
        all_params = add_imageable_from_params(restricted_image_params)
        @image = Image.new(all_params)
        authorize @image

        return render :show, status: :created, location: v1_image_url(@image) if @image.save

        render json: @image.errors, status: :unprocessable_entity
      end

      def token_generator
        @@token_generator ||= token_generator_producer.call
      end

      def token_generator_producer
        @@token_generator_producer ||= proc { |opts = {}| Utilities::TokenGenerator.new(opts) }
      end
  end
end
