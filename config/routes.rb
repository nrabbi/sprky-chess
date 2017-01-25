Rails.application.routes.draw do
  devise_for :players

  get 'static_pages/home'
  resources :games
  get '/board', to: 'games#board'
    # change this later to '/games/:id/board'

  root 'static_pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
