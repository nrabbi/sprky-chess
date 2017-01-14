Rails.application.routes.draw do
  devise_for :players
  get 'static_pages/home'

  root 'static_pages#home'
  resources :games, only: [:new, :show, :create]
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
