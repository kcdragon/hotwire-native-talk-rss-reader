Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :admin do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end

  resource :session, only: %i[ new create destroy ]
  resource :registration, only: %i[ new create ]
  resources :passwords, param: :token, only: %i[ new create edit update ]
  resource :user, only: %i[ edit update ]
  resource :guest_user, only: :create
  resource :guest_registration, only: %i[ new create ]
  resource :welcome, only: :show, controller: "welcome"
  resources :feeds, only: %i[ index new create show destroy ]
  resources :entries, only: %i[ index ] do
    member do
      patch :mark_as_read
      patch :mark_as_unread
      patch :toggle_like
    end
  end

  namespace :hotwire_native do
    resource :configuration, only: [] do
      get :android_v1
      get :ios_v1
    end
    resource :refresh, only: :show, controller: "refresh"
  end

  resource :apple_oauth_sessions, only: %i[ new create ] do
    collection do
      get :authenticate_by_token
      post :callback
    end
  end

  resource :google_oauth_sessions, only: %i[ new create ] do
    collection do
      get :authenticate_by_token
      get :callback
    end
  end

  # Defines the root path route ("/")
  root "entries#index"
end
