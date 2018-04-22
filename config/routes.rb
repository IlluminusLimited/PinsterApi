# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pin_assortments
  resources :assortments
  resources :collectable_collections
  resources :collections
  resources :pins
  resources :images
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
