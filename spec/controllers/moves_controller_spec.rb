require 'rails_helper'

RSpec.describe MovesController, type: :controller do
  let(:game) { FactoryGirl.create :game }
  let(:player) { FactoryGirl.create :player }
  let(:player2) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
  let(:sign_in_player2) { sign_in player2 }
  describe "moves#index action" do
    it "successfullies show the page" do
      game
      get :index, params: { game_id: game }
      expect(response).to have_http_status(:success)
    end
  end

  describe "moves#new action" do
    it "successfullies show the new form" do
      game
      get :new, params: { game_id: game }
      expect(response).to have_http_status(:success)
    end
  end
  describe 'moves#create action' do
    it 'successfully create a valid move' do
      player
      player2
      sign_in_player
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black")
      # move pawn from A2 to A3
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      expect(response).to redirect_to game_board_path(game)
      move = Move.last
      expect(move.from).to eq(8)
    end
    
    it 'does not create a move with invalid params' do
      game
      move_count = Move.count
      expect { post :create, params: { game_id: -2, move: { from: 128, to: -43 } } }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Move.count).to eq move_count
    end

    it "lets the player who has current turn create a move" do
      player
      player2
      sign_in_player
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black")
      move_count = Move.count
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      expect(Move.count).to eq 1
      sign_out player
      sign_in_player2
      post :create, params: { game_id: game.id, move: { from: 48, to: 32 } }
      expect(game.moves.count).to eq 2
    end

    it "prohibits the player who does not have current turn from creating a move" do
      player
      player2
      sign_in_player
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black")
      move_count = Move.count
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      expect(Move.count).to eq 1
      post :create, params: { game_id: game.id, move: { from: 16, to: 24 } }
      expect(Move.count).to eq 1
    end
  end

end
