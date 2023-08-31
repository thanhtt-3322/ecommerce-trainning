Rails.application.routes.draw do
  root "home#index"

  get "/signup", to: "registers#new", as: "signup"
  post "/signup", to: "registers#create"

  get "/signin", to: "sessions#new", as: "session"
  post "/signin", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

  resource :cart, only: %i(show create update destroy)
  resources :orders, only: %i(index create update)
  resources :products, only: %i(index show)

  namespace :admin do
    get "/home", to: "admin_home#index"
    
    resources :products, except: %i(show destroy)
  end
end
