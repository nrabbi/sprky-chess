require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:player) { FactoryGirl.create :player }
  let(:player2) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
  let(:sign_in_player2) { sign_in player2 }
  let(:post_valid_game) { post :create, params: { game: { name: "Test Game", player_1_color: "White" } } }
  let(:post_valid_unavailable_game) { post :create, params: { game: { name: "Unavailable Test Game", player_1_color: "White", player_2_id: 101 } } }
  let(:post_invalid_game) { post :create, params: { game: { name: '' } } }
  let(:patch_valid_game) { patch :update, params: { game: Game.last.id, player_2_id: player2.id } }

  describe "games#index action" do
    it "successfullies show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#new action" do
    it "requires players to be logged in" do
      get :new
      expect(response).to redirect_to new_player_session_path
    end

    it "successfullies show the new form" do
      player
      sign_in_player
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#create action" do
    it "requires players to be logged in" do
      post_valid_game
      expect(response).to redirect_to new_player_session_path
    end

    it "successfully create a new game in the database" do
      player
      sign_in_player
      post_valid_game
      expect(response).to redirect_to game_board_path(Game.last)

      game = Game.last
      expect(game.name).to eq("Test Game")
      expect(game.player_1_id).to eq(player.id)
    end
    it "properlies deal with validation errors" do
      player
      sign_in_player
      game_count = Game.count
      post_invalid_game
      expect(response).to have_http_status(:unprocessable_entity)
      expect(game_count).to eq Game.count
    end
    it "sets the player_1_id to the current_player" do
      player
      sign_in_player
      post_valid_game
      game = Game.last
      expect(game.player_1_id).to eq(player.id)
      expect(game.player_2_id).to eq(nil)
    end
    it "lets a player choose their color" do
      player
      sign_in_player
      post_valid_game
      game = Game.last
      expect(game.player_1_color).to eq("White")
    end
  end

  describe "games#available action" do
    render_views
    it "successfullies show created games which can be joined" do
      player
      sign_in_player
      post_valid_game
      post_valid_unavailable_game
      get :available
      expect(response).to have_http_status(:success)
      visit available_games_path
      expect(page).to have_content("Test Game")
      expect(page).not_to have_content("Unavailable")
    end
    it "shows the available color on available games" do
      player
      sign_in_player
      post_valid_game
      game = Game.last
      visit available_games_path
      expect(page).to have_content("Black is available")
    end
  end

  describe "games#update action" do
    it "adds current_player to current_game as player_2_id" do
      player
      player2
      sign_in_player
      post_valid_game
      sign_out player
      sign_in_player2
      game = Game.last
      patch :update, params: { id: Game.last.id, player_2_id: player2.id }
      game = Game.last.reload
      expect(game.player_2_id).to eq(player2.id)
    end

    it "should update player_2_color to the remaining color" do
      player
      player2
      sign_in_player
      post_valid_game
      sign_out player
      sign_in_player2
      game = Game.last
      patch :update, params: { id: Game.last.id, player_2_id: player2.id }
      game = Game.last.reload
      expect(game.player_2_color).to eq("Black")
    end
  end
  describe "games#player_turn action" do
      it "gets White for the initial turn" do
      player
      sign_in_player
      post_valid_game
      current_game = Game.last
      expect(controller.player_turn(current_game)).to eq "White"
    end
    it "gets Black for the second turn" do
      player
      sign_in_player
      post_valid_game
      current_game = Game.last
      # binding.pry
      current_game.moves.new(from: 8, to: 16).save
      expect(controller.player_turn(current_game)).to eq "Black"
    end
      it "gets White for an arbitrary even number of turns" do
      player
      sign_in_player
      post_valid_game
      current_game = Game.last
      current_game.moves.new(from: 8, to: 16).save
      current_game.moves.new(from: 16, to: 24).save
      current_game.moves.new(from: 24, to: 32).save
      current_game.moves.new(from: 32, to: 40).save
      expect(controller.player_turn(current_game)).to eq "White"
    end
    it "gets Black for an arbitrary odd number of turns" do
      player
      sign_in_player
      post_valid_game
      current_game = Game.last
      current_game.moves.new(from: 8, to: 16).save
      current_game.moves.new(from: 16, to: 24).save
      current_game.moves.new(from: 24, to: 32).save
      expect(controller.player_turn(current_game)).to eq "Black"
    end
  end

end
