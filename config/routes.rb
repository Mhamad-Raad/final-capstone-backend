Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post 'auth/sign_up', to: 'authentication#signup'
      post 'auth/log_in', to: 'authentication#login'
      resources :users, only: [:show, :create, :update, :destroy]
      resources :trips, only: [:show, :create, :update, :destroy]
      resources :reservations, only: [:show, :create, :update, :destroy]
    end
  end  
end
