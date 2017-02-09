require 'rails_helper'

RSpec.describe MovesController, type: :controller do
  let(:game) { FactoryGirl.create :game }
  let(:player) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
  describe "moves#index action" do
    it "should successfully show the page" do
      game
      get :index, params: { game_id: game }
      expect(response).to have_http_status(:success)
    end
  end

  describe "moves#new action" do
    it "should successfully show the new form" do
      game
      get :new, params: { game_id: game }
      expect(response).to have_http_status(:success)
    end
  end
  describe 'moves#create action' do
    # TODO -- FIX BROKEN TESTS
    it 'should successfully create a valid move' do
      game
      post :create, params: { game_id: game, move: { from: 0, to: 8 } }
      expect(response).to redirect_to game_board_path(game)
      move = Move.last
      expect(move.from).to eq(0)
    end
    it 'should not create a move with invalid params' do
      game
      move_count = Move.count
      expect { post :create, params: { game_id: -2, move: { from: 128, to: -43 } } }.to  raise_error(ActiveRecord::RecordNotFound)
      post :create, params: { game_id: game, move: { from: 128, to: -43 } }
      expect(Move.count).to eq move_count
    end
  end

end
