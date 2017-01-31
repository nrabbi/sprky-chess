Rails.application.routes.draw do
  devise_for :players

  root 'static_pages#home'
  resources :games do
    resources :moves
  end

  get '/board', to: 'games#board'
  # change this later to '/games/:id/board'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
