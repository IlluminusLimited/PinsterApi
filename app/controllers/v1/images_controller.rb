# frozen_string_literal: true

module V1
  class ImagesController < ApplicationController
    before_action :set_image, only: %i[show update destroy]

    # GET /images
    def index
      @images = Image.all

      render json: @images
    end

    # GET /images/1
    def show
      render json: @image
    end

    # POST /images
    def create
      @image = Image.new(image_params)

      if @image.save
        render :show, status: :created, location: v1_image_url(@image)
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /images/1
    def update
      if @image.update(image_params)
        render :show, status: :ok, location: v1_image_url(@image)
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end

    # DELETE /images/1
    def destroy
      @image.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_image
        @image = Image.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def image_params
        params.require(:data).permit(:imageable_id,
                                     :imageable_type,
                                     :name,
                                     :description,
                                     :base_file_name,
                                     :storage_location_uri,
                                     :featured)
      end
  end
end
