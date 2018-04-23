# frozen_string_literal: true

json.extract! user, :id, :display_name, :bio
json.url v1_user_url(user, format: :json)
