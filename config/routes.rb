# frozen_string_literal: true

Rails.application.routes.draw do
  health_check_routes

  defaults format: :json do
    get "login/:provider", to: "oauths#oauth", as: :auth_at_provider
    get "login", to: "oauths#login"
    post "oauth/callback", to: "oauths#callback"
    get "oauth/callback", to: "oauths#callback"

    concern :imageable do
      resources :images, only: %i[index create]
    end

    concern :api_base do
      resources :images, only: %i[show create update destroy]

      resources :pins, concerns: :imageable

      resources :assortments, concerns: :imageable

      resources :users, shallow: true, only: %i[index show destroy], concerns: :imageable do
        resources :collections, concerns: :imageable do
          resources :collectable_collections, shallow: true
        end
      end

      match 'me' => 'me#show', via: :get
      match 'me' => 'me#update', via: %i[patch put]
      match '/search' => 'searches#index', via: :get
    end

    namespace :v1 do
      concerns :api_base
    end

    root to: redirect('/docs')
  end
  get 'static/legal'
  apipie
end
