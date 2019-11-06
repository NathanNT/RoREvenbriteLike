Rails.application.routes.draw do
  devise_for :users
  resources :attendances
  resources :events
  resources :users
  resources :teams, only: [:index]
  resources :contacts, only: [:index]
  root 'events#index'
end
