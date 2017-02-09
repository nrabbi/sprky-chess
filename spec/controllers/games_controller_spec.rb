require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:player) { FactoryGirl.create :player }
  let(:player2) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
  let(:post_valid_game) { post :create, params: { game: { name: "Test Game", player_1_color: "White" } } }
  let(:post_valid_unavailable_game) { post :create, params: { game: { name: "Unavailable Test Game", player_1_color: "White", player_2_id: 101 } } }
  let(:post_invalid_game) { post :create, params: { game: { name: '' } } }
  let(:patch_valid_game) { patch :update, params: { game: { id: Game.last.id, player_2_id: player2.id } } }
  

  describe "games#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#new action" do
    it "should require players to be logged in" do
      get :new
      expect(response).to redirect_to new_player_session_path
    end

    it "should successfully show the new form" do
      player
      sign_in_player
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "games#create action" do
    it "should require players to be logged in" do
      post_valid_game
      expect(response).to redirect_to new_player_session_path
    end

    it "should successfully create a new game in the database" do
      player
      sign_in_player
      post_valid_game
      expect(response).to redirect_to game_path(Game.last)

      game = Game.last
      expect(game.name).to eq("Test Game")
      expect(game.player_1_id).to eq(player.id)
    end
      it "should properly deal with validation errors" do
        player
        sign_in_player
        game_count = Game.count
        post_invalid_game
        expect(response).to have_http_status(:unprocessable_entity)
        expect(game_count).to eq Game.count
      end
      it "should set the player_1_id to the current_player" do
        player
        sign_in_player
        post_valid_game
        game = Game.last
        expect(game.player_1_id).to eq(player.id)
        expect(game.player_2_id).to eq(nil)
      end
        it "should let a player choose their color" do
        player
        sign_in_player
        post_valid_game
        game = Game.last
        expect(game.player_1_color).to eq("White")
      end
    end

  describe "games#available action" do
    render_views
    it "should successfully show created games which can be joined" do
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
    it "should show the available color on available games" do
      player
      sign_in_player
      post_valid_game
      game = Game.last
      visit available_games_path
      expect(page).to have_content("Black is available")
    end
  end

  describe "games#update action" do
    it "should add current_player to current_game as player_2_id" do
      player
      sign_in_player
      post_valid_game
      player2
      sign_in_player
      game = Game.last
      game.update(player_2_id: player2.id)
      expect(game.player_2_id).to eq(player2.id)
    end
    # it "should update player_2_color to the remaining color" do
    #   player
    #   sign_in_player
    #   post_valid_game
    #   player2
    #   sign_in_player
    #   binding.pry
    #   patch_valid_game
    #   game = Game.last.reload
    #   expect(game.player_2_color).to eq("Black")
    # end
  end

end
