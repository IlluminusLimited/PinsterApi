# frozen_string_literal: true

json.extract! @user, :id, :display_name, :bio
json.images @user.images, partial: 'v1/images/image', as: :image if @user.association(:images).loaded?

json.collections_url v1_user_collections_url(@user)
json.collections_summary_url v1_user_collections_summary_url(@user)
json.images_url v1_user_images_url(@user, format: :json)
json.url v1_user_url(@user, format: :json)
