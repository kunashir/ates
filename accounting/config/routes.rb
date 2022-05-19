Rails.application.routes.draw do
  get 'dashboard/main'
  get 'dashboard/popug'
  get 'dashboard/manager'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'auth/:provider/callback', to: 'auth#callback'
  get '/login', to: 'auth#login'
  get '/logout', to: 'auth#logout'
  root "dashboard#main"
  # root "articles#index"
end
