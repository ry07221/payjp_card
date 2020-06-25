Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root 'items#index'

  resources :users, only: [:show, :update]
  resources :cards, only: [:new, :create] 
  resources :items do
    member do
      post "order"
    end
  end

end
