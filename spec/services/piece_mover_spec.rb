require 'rspec'
require 'rails_helper'

describe 'PieceMover' do

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
      # ???????????????????

      # 2 moves should exist in db. The move to to_pos and captured piece off board. ORDER MATTERS
      # inserted = Move.last(2)
      # expect(inserted.length).to eq(2)

      # # Check that the captured piece was moved off board
      # capture_move = inserted[0]
      # capture_from = Position.new_from_int(capture_move.from)
      # capture_to = Position.new_from_int(capture_move.to)

      # black_capture_pos = Position.new_from_int(Position::BLACK_CAPTURE_INT)

      # expect(capture_from.equals?(to_pos)).to eq true
      # expect(capture_to.equals?(black_capture_pos)).to eq true

      # # Check that the piece was moved to the to_pos
      # move = inserted[1]
      # move_from = Position.new_from_int(move.from)
      # move_to = Position.new_from_int(move.to)

      # expect(move_from.equals?(from_pos)).to eq true
      # expect(move_to.equals?(to_pos)).to eq true

    end

    it "returns false if move is obstructed" do
      game
      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      obstructor_piece = ChessPiece.new(:white, Position.new(3, 0))
      pieces = [rook, obstructor_piece]

      new_move = game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

      # OBSTRUCTED MOVE
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
  end

end
