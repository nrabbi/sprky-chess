require 'rspec'
require 'rails_helper'

describe 'PieceMover' do

  describe 'PieceMover#move_to!' do
    piece_mover = PieceMover.new
    let(:game) { FactoryGirl.create :game }

    it 'moves a piece to an empty square if the move is valid and is not obstructed. returns true.' do
      game
      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      pieces = [rook]

      move_resolution = PieceMover.move_to!(pieces, game.moves, from_pos.to_integer, to_pos.to_integer)
      expect(move_resolution.ok?).to eq true

    end

    it 'captures a piece BEFORE performing a move if the move is valid, unobstructed, and the square can be captured. returns true.' do
      game

      from_pos = Position.new(0, 0)
      to_pos = Position.new(5, 0)

      rook = Rook.new(:white, from_pos)
      capture_piece = Pawn.new(:black, to_pos)
      pieces = [rook, capture_piece]

      move_resolution = PieceMover.move_to!(pieces, game.moves, from_pos.to_integer, to_pos.to_integer)
      expect(move_resolution.ok?).to eq true

      game.moves.new(from: from_pos.to_integer, to: to_pos.to_integer)

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

    it "returns false if move is invalid or obstructed" do
      # pending("Implementation not done yet")
      # from_pos = Position.new(0, 0)
      # to_pos = Position.new(5, 0)

      # rook = Rook.new(:white, from_pos)
      # obstructor_piece = ChessPiece.new(:white, Position.new(3, 0))
      # pieces = [rook, obstructor_piece]

      # # OBSTRUCTED MOVE
      # success = piece_mover.move_to!(rook, to_pos, pieces)
      # expect(success).to eq false

      # # check no move in db
      # inserted1 = Move.last
      # obstructed_move_created = true
      # if inserted1.nil?
      #   obstructed_move_created = false
      # else
      #   # last move should not equal this move
      #   move_from = Position.new_from_int(inserted1.from)
      #   move_to = Position.new_from_int(inserted1.to)
      #   obstructed_move_created = (move_from.equals?(from_pos) && move_to.equals(to_pos))
      # end

      # expect(obstructed_move_created).to eq(false)

      # # INVALID MOVE
      # to_pos = Position.new(-10, -10)
      # success = piece_mover.move_to!(rook, to_pos, pieces)
      # expect(success).to eq false

      # # check no move
      # inserted2 = Move.last
      # invalid_move_created = true
      # if inserted2.nil?
      #   invalid_move_created = false
      # else
      #   # last move should not equal this move
      #   move_from = Position.new_from_int(inserted2.from)
      #   move_to = Position.new_from_int(inserted2.to)
      #   invalid_move_created = (move_from.equals?(from_pos) && move_to.equals(to_pos))
      # end

      # expect(invalid_move_created).to eq(false)

    end
  end

end
