# frozen_string_literal: true

json.array! @users, partial: 'v1/users/user', as: :user
