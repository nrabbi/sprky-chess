require 'rails_helper'

RSpec.describe MovesController, type: :controller do
  let(:game) { FactoryGirl.create :game }
  let(:player) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
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
      game
      # move pawn from A2 to A3
      post :create, params: { game_id: game, move: { from: 8, to: 16 } }
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
  end

end
