Rails.application.routes.draw do

  resource :session
  resources :passwords, param: :token

  root "homes#top"

  get "about", to: "homes#about"
  get "search", to: "searches#search", as: :search

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :admin do
    root to: "homes#top"

    get "sign_in", to: "sessions#new", as: :sign_in
    post "sign_in", to: "sessions#create", as: :session
    delete "sign_out", to: "sessions#destroy", as: :sign_out

    resources :users, only: [:index, :show, :destroy]

    resources :posts, only: [:index, :show, :destroy] do
      resources :comments, only: [:index, :show, :destroy]
    end

    resources :comments, only: [:index, :show, :destroy]
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
