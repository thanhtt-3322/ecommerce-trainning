Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registers", sessions: "sessions",
                                    confirmations: "confirmations" }

  root "home#index"

  resource :cart, only: %i(show create update destroy)
  resources :orders, only: %i(index create update)
  resources :products, only: %i(index show)

  namespace :admin do
    get "/home", to: "home#index"
    
    resources :products, except: %i(show destroy)
    resources :orders, only: %i(index edit update)
    resources :users, only: %i(index update)
  end
end
