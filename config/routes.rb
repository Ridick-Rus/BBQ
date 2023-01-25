Rails.application.routes.draw do
  # корень сайта
  root to: "events#index"

  resources :users, only: [:show, :edit, :update]
  resources :events
end
