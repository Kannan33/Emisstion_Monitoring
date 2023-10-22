Rails.application.routes.draw do
  devise_for :rto_officers, controllers: {
    registrations: 'rto_officers/registrations'
  }
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#home'
  resources :vehicles do
    get :pending_verification, on: :collection
    get :search, on: :collection
  end

  namespace :api do
    namespace :v1 do
      post '/vehicle_records', to: 'vehicle_records#create'
    end
  end

end
