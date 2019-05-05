# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :require_login, except: %i[show create]
    before_action :set_user, only: %i[show]
    after_action :verify_authorized, except: [:create]

    api :GET, '/v1/users', 'List users'

    def index
      @users = User.all
      authorize @users

      render :index
    end

    api :GET, '/v1/users/:id', 'Show a user'
    param :id, String, allow_nil: false

    def show
      authorize @user
      render :show
    end

    api :POST, '/v1/users', 'Create a user'
    param :display_name, String, allow_nil: false
    param :avatar_uri, String, allow_nil: true
    error :unauthorized, 'Request missing Authorization header'
    error :unprocessable_entity, 'Unprocessable entity, please check the payload'

    def create
      token = http_token
      return not_authenticated unless token

      @user = process_user_create(token)
      authorize @user

      if @user.save
        save_avatar
        render :show, status: :created, location: v1_user_url(@user)
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/v1/users/:id', 'Destroy a user'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      @user = User.includes(:images, collections: %i[images collectable_collections]).find(params[:id])

      authorize @user
      @user.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.includes(:images).find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:data).permit(policy(@user).permitted_attributes)
      end

      def user_creation_params
        params.require(:data).permit(:display_name, :avatar_uri)
      end

      def process_user_create(token)
        access_token, _access_token_headers = current_user_factory.token_verifier.call(token)

        display_name = user_creation_params['display_name']

        User.new(display_name: display_name, external_user_id: access_token['sub'])
      end

      def save_avatar
        avatar_uri = user_creation_params['avatar_uri']

        if avatar_uri
          Image.create(base_file_name: avatar_uri,
                       storage_location_uri: avatar_uri,
                       thumbnailable: false,
                       imageable: @user)
        end
        nil
      end
  end
end
