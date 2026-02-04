Rails.application.routes.draw do

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post 'guest_login', to: 'sessions#guest_create'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get "schedules/update"
  get "vehicle_assignments/create"
  get "vehicle_assignments/destroy"
  get "placements/new"
  get "placements/create"
  get "placements/destroy"
  get "dashboards/show"

  resources :members do
    member do
      patch :move_up
      patch :move_down
    end
  end

  resources :vehicles do
    member do
      patch :move_up
      patch :move_down
    end
  end

  resources :sites do
    member do
      patch :move_up
      patch :move_down
    end
  end


  resources :placements, only: [:create, :destroy] do
    member do
      patch :move_up
      patch :move_down
    end
  end

  resources :vehicle_assignments, only: [:create]

  resources :schedules, only: [] do
    collection do
      patch :update_memo
    end
  end

  resource :dashboard, singleton: true, controller: 'dashboards' do
    get :weekly_report
  end

  resources :users, only: [:new, :create, :edit, :update]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  resource :dashboard, singleton: true, controller: 'dashboards'
  root "dashboards#show"
end
