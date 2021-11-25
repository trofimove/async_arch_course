Rails.application.routes.draw do
  root "balances#index"

  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions

  resources :balances, only: [:index]

end
