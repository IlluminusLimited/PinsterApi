# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :require_login

    before_action :set_user, only: %i[show update destroy]

    # GET /users
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/users', 'List users'
    def index
      @users = User.all

      render json: @users
    end

    # GET /users/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/users/:id', 'Show an user'
    error code: 401
    def show
      render json: @user
    end

    # POST /users
    def create
      @user = User.new(user_params)

      if @user.save
        render show: @user, status: :created, location: v1_user_url(@user)
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render show: @user, status: :ok, location: v1_user_url(@user)
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
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
