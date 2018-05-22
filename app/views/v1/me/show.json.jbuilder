# frozen_string_literal: true

json.extract! @user, :id, :email, :display_name, :bio, :role
json.images @user.images_or_placeholder, partial: 'v1/images/image', as: :image if @user.association(:images).loaded?
json.url v1_user_url(@user, format: :json)
