# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'home#show', as: 'home'
  resources :groups, only: %i[new create show edit update], param: :url_slug do
    resources :talks, only: %i[new create], module: 'groups'
    resources :talk_suggestions, only: %i[new create], module: 'groups'
  end
  resources :users, only: %i[new create]

  get 'login', to: 'sessions#new', as: 'sessions'
  post 'login', to: 'sessions#create', as: 'new_session'
  delete 'logout', to: 'sessions#destroy', as: 'session'
end
