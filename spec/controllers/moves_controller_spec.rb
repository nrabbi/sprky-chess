require 'rails_helper'

RSpec.describe MovesController, type: :controller do
  let(:game) { FactoryGirl.create :game }
  let(:player) { FactoryGirl.create :player }
  let(:player2) { FactoryGirl.create :player }
  let(:sign_in_player) { sign_in player }
  let(:sign_in_player2) { sign_in player2 }
  describe "moves#index action" do
    it "shows the page" do
      game
      get :index, params: { game_id: game }
      expect(response).to have_http_status(:success)
    end
  end

  describe "moves#new action" do
    it "shows the new form" do
      game
      get :new, params: { game_id: game }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'moves#create action' do
    it 'creates a valid move' do
      player
      player2
      sign_in_player
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      # expect(response).to redirect_to game_board_path(game)
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
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
      move_count = Move.count
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      expect(Move.count).to eq 1
      sign_out player
      sign_in_player2
      post :create, params: { game_id: game.id, move: { from: 48, to: 40 } } #
      expect(game.moves.count).to eq 2
    end

    it "prohibits the player who does not have current turn from creating a move" do
      player
      player2
      sign_in_player
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      expect(Move.count).to eq 1
      post :create, params: { game_id: game.id, move: { from: 16, to: 24 } }
      expect(Move.count).to eq 1
    end

    it "prohibits new move when only 1 player" do
      player
      game = FactoryGirl.create(:game, player_1_id: player.id)
      move_count = Move.count
      post :create, params: { game_id: game.id, move: { from: 8, to: 16 } }
      expect(Move.count).to eq 0
    end

    it "prohibits a player from moving the other player's pieces" do
      player
      player2
      sign_in_player
      game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
      post :create, params: { game_id: game.id, move: { from: 48, to: 32 } }
      expect(Move.count).to eq 0
    end

    context "when Castler get valid castle" do
      it "returns updated move" do
        player
        player2
        sign_in_player
        game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
        move1 = game.moves.new(game_id: game.id, from: 6, to: 23).save
        move2 = game.moves.new(game_id: game.id, from: 48, to: 40).save
        move3 = game.moves.new(game_id: game.id, from: 14, to: 22).save
        move4 = game.moves.new(game_id: game.id, from: 49, to: 41).save
        move5 = game.moves.new(game_id: game.id, from: 5, to: 14).save
        move6 = game.moves.new(game_id: game.id, from: 50, to: 42).save

        post :create, params: { game_id: game.id, move: { from: 4, to: 7 } }
        move = Move.last
        # tests that Castler updated the move positions
        expect(move.from).to eq(4)
        expect(move.to).to eq(6)
      end
    end

    context "when Castler get invalid castle" do
      it "does not create move if obstructed" do
        player
        player2
        sign_in_player
        game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
        move1 = game.moves.new(game_id: game.id, from: 6, to: 23).save
        move2 = game.moves.new(game_id: game.id, from: 48, to: 40).save
        move3 = game.moves.new(game_id: game.id, from: 14, to: 22).save
        move4 = game.moves.new(game_id: game.id, from: 49, to: 41).save
        # Castle is still obstructed. Should not create new move.
        post :create, params: { game_id: game.id, move: { from: 4, to: 7 } }
        move = Move.last
        expect(move.from).to eq(49)
        expect(move.to).to eq(41)
      end
      it "does not create move if piece has moved before" do
        player
        player2
        sign_in_player
        game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
        move1 = game.moves.new(game_id: game.id, from: 6, to: 23).save
        move2 = game.moves.new(game_id: game.id, from: 48, to: 40).save
        move3 = game.moves.new(game_id: game.id, from: 14, to: 22).save
        move4 = game.moves.new(game_id: game.id, from: 49, to: 41).save
        move5 = game.moves.new(game_id: game.id, from: 5, to: 14).save
        move6 = game.moves.new(game_id: game.id, from: 50, to: 42).save
        move7 = game.moves.new(game_id: game.id, from: 4, to: 5).save
        move8 = game.moves.new(game_id: game.id, from: 51, to: 43).save
        move9 = game.moves.new(game_id: game.id, from: 5, to: 4).save
        move8 = game.moves.new(game_id: game.id, from: 52, to: 44).save
        post :create, params: { game_id: game.id, move: { from: 4, to: 7 } }
        move = Move.last
        expect(move.from).to eq(52)
        expect(move.to).to eq(44)
      end
      it "does not create move if wrong pieces" do
        player
        player2
        sign_in_player
        game = FactoryGirl.create(:game, player_1_id: player.id, player_2_id: player2.id, player_2_color: "Black", status: "started")
        move1 = game.moves.new(game_id: game.id, from: 6, to: 23).save
        move2 = game.moves.new(game_id: game.id, from: 48, to: 40).save
        move3 = game.moves.new(game_id: game.id, from: 14, to: 22).save
        move4 = game.moves.new(game_id: game.id, from: 49, to: 41).save
        move5 = game.moves.new(game_id: game.id, from: 5, to: 14).save
        move6 = game.moves.new(game_id: game.id, from: 50, to: 42).save

        post :create, params: { game_id: game.id, move: { from: 4, to: 6 } }
        move = Move.last
        expect(move.from).to eq(50)
        expect(move.to).to eq(42)
        
        post :create, params: { game_id: game.id, move: { from: 3, to: 7 } }
        move = Move.last
        expect(move.from).to eq(50)
        expect(move.to).to eq(42)
      end
    end
  end

end
