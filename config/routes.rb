# frozen_string_literal: true

Rails.application.routes.draw do
  health_check_routes

  defaults format: :json do
    get  "login/:provider", to: "oauths#oauth", as: :auth_at_provider
    get  "login",           to: "oauths#login"
    post "oauth/callback",  to: "oauths#callback"
    get  "oauth/callback",  to: "oauths#callback"

    concern :api_base do
      resources :collections
      resources :collectable_collections
      resources :pins
      resources :users
      resources :assortments
      resources :pin_assortments
      match 'me' => 'me#show', :via => :get
      match 'me' => 'me#update', :via => :patch
      match 'me' => 'me#update', :via => :put
    end

    namespace :v1 do
      concerns :api_base
    end

    root to: 'pins#index'
  end

  apipie
end
