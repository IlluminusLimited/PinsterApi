# frozen_string_literal: true

Rails.application.routes.draw do
  health_check_routes

  defaults format: :json do
    get  "login/:provider", to: "oauths#oauth", as: :auth_at_provider
    get  "login",           to: "oauths#login"
    post "oauth/callback",  to: "oauths#callback"
    get  "oauth/callback",  to: "oauths#callback"

    concern :api_base do
      resources :pins
      resources :collectable_collections
      resources :assortments
      resources :pin_assortments

      resources :users, shallow: true do
        resources :collections
      end

      match 'me' => 'me#show', via: :get
      match 'me' => 'me#update', via: %i[patch put]
    end

    namespace :v1 do
      concerns :api_base
    end

    root to: 'v1/pins#index'
  end

  apipie
end
