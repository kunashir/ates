Rails.application.routes.draw do
  resources :tasks, only: [:index, :new, :create, ] do
    collection do
      get 'shuffle'
    end
    member do
      get 'close'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'auth/:provider/callback', to: 'auth#callback'
  get '/login', to: 'auth#login'
  get '/logout', to: 'auth#logout'
  root "tasks#index"
end
