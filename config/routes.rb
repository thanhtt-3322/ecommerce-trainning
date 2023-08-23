Rails.application.routes.draw do
  root "home#index"

  get "/signup", to: "registers#new", as: "signup"
  post "/signup", to: "registers#create"

  get "/signin", to: "sessions#new", as: "session"
  post "/signin", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"
end
