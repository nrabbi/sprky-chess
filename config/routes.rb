Rails.application.routes.draw do
  devise_for :players

  root 'static_pages#home'
  get 'about/team', to: 'static_pages#team', as: 'team'
  get 'about/privacy_policy', to: 'static_pages#privacy', as: 'privacy'
  get 'games/:id/board', to: 'games#board', as: 'game_board'
  get 'games/:id/join_game', to: 'games#join_game', as: 'join_game'
  get 'games/available', to: 'games#available', as: 'available_games'
  # change this later to '/games/:id/board'
  resources :games do
    resources :moves, only: [:new, :create, :index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
