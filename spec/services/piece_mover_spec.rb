require 'rspec'
require 'rails_helper'

describe 'PieceMover' do

  describe 'PieceMover#promote' do
    it 'does nothing if selected promo type is not one of {Q, B, K, R}' do
      pawn = Pawn.new(:white, Position.new(0, 7))
      pieces = [pawn]
      promo = 'WRONG'
      PieceMover::promote(pawn, promo, pawn)

      # no change
      expect(pieces[0]).to eq pawn
    end

    it 'replaces a piece with the appropriate promotion piece and same position' do
      pawn = Pawn.new(:white, Position.new(0,7))
      pieces = [pawn]
      promo = 'Q'
      PieceMover::promote(pawn, promo, pieces)
      expect(pieces[0].class).to eq Queen
      expect(pieces[0].position.equals?(pawn.position)).to eq true

      promo = 'K'
      pieces = [pawn]
      PieceMover::promote(pawn, promo, pieces)
      expect(pieces[0].class).to eq Knight
      expect(pieces[0].position.equals?(pawn.position)).to eq true

      promo = 'B'
      pieces = [pawn]
      PieceMover::promote(pawn, promo, pieces)
      expect(pieces[0].class).to eq Bishop
      expect(pieces[0].position.equals?(pawn.position)).to eq true

      promo = 'R'
      pieces = [pawn]
      PieceMover::promote(pawn, promo, pieces)
      expect(pieces[0].class).to eq Rook
      expect(pieces[0].position.equals?(pawn.position)).to eq true
    end
  end

  describe 'PieceMover#move_to!' do
    piece_mover = PieceMover.new
    let(:game) { FactoryGirl.create :game }

    it 'captures a piece BEFORE performing a move if the move is valid, unobstructed, and the square can be captured. returns true.' do
      game

      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      capture_piece = Pawn.new(:black, to_pos)
      pieces = [rook, capture_piece]

      white_capture_area_pos = Position.new_from_int(Position::WHITE_CAPTURE_INT)

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq true
      # check that the black pawn is captured
      expect(move_resolution.pieces[1].position.equals?(white_capture_area_pos)).to eq true
    end

    it "a pawn captures another chess piece" do
      game
      from_pos = Position.new(3, 4)
      to_pos = Position.new(4, 5)

      white_pawn = Pawn.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_pawn, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      unless move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a rook captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(3, 0)

      white_rook = Rook.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_rook, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      unless move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a queen captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(3, 0)

      white_queen = Queen.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_queen, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      unless move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a king captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(2, 0)

      white_king = King.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_king, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      unless move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a bishop captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(7, 6)

      white_bishop = Bishop.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_bishop, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      unless move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "a knight captures another chess piece" do
      game
      from_pos = Position.new(1, 0)
      to_pos = Position.new(0, 2)

      white_knight = Knight.new(:white, from_pos)
      black_pawn = Pawn.new(:black, to_pos)

      pieces = [white_knight, black_pawn]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      unless move_resolution.ok?
        puts "Move Resolution: #{move_resolution.error_message}"
      end
      expect(move_resolution.ok?).to eq true
      expect(move_resolution.pieces.count).to eq(pieces.count)
      expect(move_resolution.pieces[1].position.equals?(Position.new_from_int(Position::WHITE_CAPTURE_INT))).to eq true
    end

    it "returns false if move is obstructed" do
      game
      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 0))
      pieces = [rook, obstructor_piece]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq false
    end

    it "raises an ArgumentError for invalid positions" do
      game

      # INVALID MOVE
      to_pos = Position.new(-10, -10)

      from_pos = Position.new(0, 0)

      rook = Rook.new(:white, from_pos)
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 0))
      pieces = [rook, obstructor_piece]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      expect { PieceMover.move_to!(pieces, game.moves) }.to raise_error(ArgumentError)
    end

    it 'moves a piece to an empty square if the move is valid and is not obstructed.' do
      game
      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      pieces = [rook]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq true
    end

    it 'detects I am moving myself into check' do 
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # K,0,0,x,0,0,R,0
      game
      from_pos = Position.new(3, 0)
      to_pos = Position.new(3, 3)

      white_rook = Rook.new(:white, Position.new(6, 0))
      black_rook = Rook.new(:black, from_pos)
      black_king = King.new(:black, Position.new(0, 0))

      pieces = [white_rook, black_king, black_rook]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      move_resolution = PieceMover.move_to!(pieces, game.moves)
      expect(move_resolution.ok?).to eq false
    end 

    it 'detects a check mate situation' do
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # R,0,0,0,0,0,0,0
      # R,0,0,0,0,0,K,0
      game

      white_rook0 = Rook.new(:white, Position.new(0, 0))
      white_rook1 = Rook.new(:white, Position.new(0, 1))

      black_king = King.new(:black, Position.new(6, 0))

      pieces = [white_rook0, white_rook1, black_king]

      is_in_check_mate = PieceMover.is_in_check_mate(:black, pieces)

      expect(is_in_check_mate).to eq true
    end

    it 'detects a piece can block a check situation ' do
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,R,0,0
      # R,0,0,0,0,0,0,0
      # R,0,0,0,0,0,K,0
      game

      white_rook0 = Rook.new(:white, Position.new(0, 0))
      white_rook1 = Rook.new(:white, Position.new(0, 1))

      black_king = King.new(:black, Position.new(6, 0))
      black_rook = Rook.new(:black, Position.new(5, 2))

      pieces = [white_rook0, white_rook1, black_king, black_rook]

      is_in_check_mate = PieceMover.is_in_check_mate(:black, pieces)

      expect(is_in_check_mate).to eq false
    end
  end

end
