# frozen_string_literal: true

json.extract! user, :id, :display_name, :bio
json.images user.images, partial: 'v1/images/image', as: :image if user.association(:images).loaded?
json.url v1_user_url(user, format: :json)
