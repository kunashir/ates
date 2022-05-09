Rails.application.routes.draw do
  use_doorkeeper
  devise_for :accounts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "accounts#index"
  resources :accounts, only: [:destroy, :edit, :update]
  get "/accounts/current", to: "accounts#current"
end
