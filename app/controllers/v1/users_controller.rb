# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: %i[show destroy]

    api :GET, '/v1/users', 'List users'

    def index
      @users = User.all
      authorize @users

      render json: @users
    end

    api :GET, '/v1/users/:id', 'Show a user'
    param :user_id, String, allow_nil: false
    def show
      authorize @user
      render json: @user
    end

    def destroy
      authorize @user
      @user.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:data).permit(:email, :display_name, :bio)
      end
  end
end
