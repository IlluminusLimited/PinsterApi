# frozen_string_literal: true

Rails.application.routes.draw do
  health_check_routes

  defaults format: :json do
    concern :imageable do
      resources :images, only: %i[index create]
    end

    concern :api_base do
      resources :images, only: %i[show create update destroy]

      resources :pins, concerns: :imageable, imageable_type: 'Pin'

      resources :assortments, concerns: :imageable, imageable_type: 'Assortment'

      resources :users,
                shallow: true,
                only: %i[index show create destroy],
                concerns: :imageable,
                imageable_type: 'User' do
        get 'collections/summary' => 'collections#summary'
        resources :collections, concerns: :imageable, imageable_type: 'Collection' do
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
