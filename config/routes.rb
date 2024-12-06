Rails.application.routes.draw do
  get "builder", to: 'builder#index'
  get "borderless", to: 'builder#borderless'
  get "cube", to: 'builder#cube'

  resources :builder, only: [:index] do
    collection do
      post :save
      get :load
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  get 'git_operations', to: 'git_operations#index'
  post 'git/commit', to: 'git_operations#commit'
  post 'git/push', to: 'git_operations#push'
end
