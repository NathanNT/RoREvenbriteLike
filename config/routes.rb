Rails.application.routes.draw do
  devise_for :users
  resources :attendances
  resources :events
  resources :users
  resources :team, only: [:index]
  resources :contact, only: [:index]
  root 'events#index'
end
