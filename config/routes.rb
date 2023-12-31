Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "paintings#index"

  resources :paintings, only: %i[index create show] do
    resource :canvas, only: %i[show]
    resources :pixel_changes, only: %i[create]
    resources :pixels, only: %i[index]
  end
end
