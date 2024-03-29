Rails.application.routes.draw do
  resources :photos
  resources :subscriptions
  # дергаем спец. девайзовский метод, который генерит все нужные ему пути
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "events#index"

  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
    # Вложенные в ресурс события ресурсы фотографий
    resources :photos, only: [:create, :destroy]

    post :show, on: :member
  end
  resources :users, only: [:show, :edit, :update]
end
