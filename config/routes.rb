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

  # --- ここを修正：引き継ぎとリセットのルートを追加 ---
  resources :schedules, only: [] do
    collection do
      patch :update_memo
      post :copy_pre_week  # 前週引き継ぎ用
      delete :reset_week   # リセット用
    end
  end

  resource :dashboard, singleton: true, controller: 'dashboards' do
    get :weekly_report
  end

  resources :users, only: [:new, :create, :edit, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "dashboards#show"
end
