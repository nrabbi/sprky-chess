require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:player) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
  let(:post_valid_game) { post :create, params: { game: { name: "Test Game" } } }
  let(:post_invalid_game) { post :create, params: { game: { name: '' } } }

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
      post_invalid_game
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
      it 'should let a player choose their color' do
      end
    end

end
