Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root 'items#index'

  resources :cards, only: [:index, :new, :create] 
  resources :items do
    member do
      post "order"
    end
  end

end
