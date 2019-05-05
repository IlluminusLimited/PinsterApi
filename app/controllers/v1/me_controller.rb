# frozen_string_literal: true

module V1
  class MeController < ApplicationController
    # The order of these actions matter. set_me loads the user using with_images. Then
    # require_login makes sure the user is actually a user.
    before_action :set_me
    before_action :require_login
    after_action :verify_authorized

    resource_description do
      description <<-DESCRIPTION
        All Me requests **require** authentication via the `Authorization` header.
      DESCRIPTION
    end

    api :GET, '/v1/me', 'Show the current user'
    error :unauthorized, 'Request missing Authorization header'
    def show
      authorize @user
      render :show
    end

    api :PATCH, '/v1/me', 'Update the current user'
    api :PUT, '/v1/me', 'Update the current user'
    param :display_name, String, desc: 'The name to be shown to other users'
    param :bio, String, desc: 'A short description of yourself'
    error :unauthorized, 'Request missing Authorization header'
    error :unprocessable_entity, 'Unprocessable entity, please check the payload'
    def update
      authorize @user

      if @user.update(me_params)
        render :show, status: :ok, location: v1_me_url(@user)
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def self.policy_class
      UserPolicy
    end

    private

      # By nature no other users can edit other user's because we don't accept
      # an external parameter for user_id
      def set_me
        @user = current_user_with_images
      end

      def me_params
        params.require(:data).permit(policy(@user).permitted_attributes)
      end
  end
end
