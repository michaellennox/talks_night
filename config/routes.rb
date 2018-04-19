# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'home#show', as: 'home'
  resources :users, only: %i[new create]
end
