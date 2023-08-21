Rails.application.routes.draw do
  root "home#index"
  get "/signup", to: "registers#new", as: "signup"
  post "/signup", to: "registers#create"
end
