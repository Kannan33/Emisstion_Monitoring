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
    get 'download_emission_records', on: :member, to: 'vehicles#download_emission_records'
    get :approve_vehicle, on: :member
    get :search, on: :collection
  end


  namespace :api do
    namespace :v1 do
      post '/vehicle_records', to: 'vehicle_records#create'
    end
  end

end
