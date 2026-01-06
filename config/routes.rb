Rails.application.routes.draw do
  resources :registrations, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  # API routes
  namespace :api do
    namespace :v1 do
      # Аутентификация
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      post 'auth/logout', to: 'auth#logout'
      get 'auth/me', to: 'auth#me'

      # Посты
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"
end
