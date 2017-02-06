require 'rails_helper'

RSpec.describe MovesController, type: :controller do
  describe "moves#index action" do
    it "should successfully show the page" do
      @game = FactoryGirl.create(:game)
      get :index, params: { game_id: @game }
      expect(response).to have_http_status(:success)
    end
  end

  describe "moves#new action" do
    it "should successfully show the new form" do
      @game = FactoryGirl.create(:game)
      get :new, params: { game_id: @game }
      expect(response).to have_http_status(:success)
    end
  end
  describe 'moves#create action' do
    # FIX THIS
    # it 'should successfully create a move' do
    #   @game = FactoryGirl.create(:game)
    #   # binding.pry
    #   post :create, "games/#{@game.id}/moves", params: { move: { game_id: @game, from: 0, to: 8 } }
    #   expect(response).to redirect_to game_board_path(@game)
    #   # move = Move.last
    #   # expect(move.from).to eq(0)
    # end
  end

end
