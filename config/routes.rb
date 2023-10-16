Rails.application.routes.draw do
  devise_for :rto_officers
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#home"

  resources :vehicles, only: [:index, :new, :create, :edit, :update, :destroy]


end
