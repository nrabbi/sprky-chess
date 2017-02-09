Rails.application.routes.draw do
  devise_for :players

  root 'static_pages#home'
  get 'games/:id/board', to: 'games#board', as: 'game_board'
  get 'games/available', to: 'games#available', as: 'available_games'
  # change this later to '/games/:id/board'
  resources :games do
    resources :moves, only: [:new, :create, :show, :index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
