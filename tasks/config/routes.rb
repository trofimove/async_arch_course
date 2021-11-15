Rails.application.routes.draw do
  root "tasks#index"

  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions

  resources :tasks do
    collection do
      post :assign_all
    end

    member do
      post :done
    end
  end
end
