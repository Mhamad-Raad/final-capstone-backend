Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  default_url_options :host => "https://capstone-backend-gz9j.onrender.com"
  namespace :api do
    namespace :v1 do
      post 'auth/sign_up', to: 'authentication#signup'
      post 'auth/log_in', to: 'authentication#login'
      resources :users, only: [:show, :create, :update, :destroy]
      resources :trips, only: [:index, :show, :create, :update, :destroy]
      resources :reservations, only: [:create, :index]
    end
  end
end
