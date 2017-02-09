require 'rspec'
require 'rails_helper'

describe 'PieceMover' do

  describe 'PieceMover#move_to!' do
    piece_mover = PieceMover.new
    it 'moves a piece to an empty square if the move is valid and is not obstructed' do
      pending("Implementation not done yet")
      orig_pos = Position.new(0,0)
      destination = Position.new(5, 0)

      rook = Rook.new(:white, orig_pos)
      pieces = [rook]

      piece_mover.move_to!(rook, destination, pieces)

      # move should exist in db with from and to positions
      inserted_from = Position.new_from_int(Move.last!.from)
      inserted_to = Position.new_from_int(Move.last!.to)

      expect(inserted_from.equals?(orig_pos)).to eq true
      expect(inserted_to.equals?(destination)).to eq true


    end

    it 'captures a piece BEFORE performing a move if the move is valid, unobstructed, and the square can be captured' do
      pending("Implementation not done yet")
      orig_pos = Position.new(0,0)
      destination = Position.new(5, 0)

      rook = Rook.new(:white, orig_pos)
      capture_piece = ChessPiece.new(:black, destination)
      pieces = [rook, capture_piece]

      piece_mover.move_to!(rook, destination, pieces)

      # 2 moves should exist in db. The move to destination and captured piece off board. ORDER MATTERS
      inserted = Move.last(2)
      expect(inserted.length).to eq(2)


      # Check that the captured piece was moved off board
      capture_move = inserted[0]
      capture_from = Position.new_from_int(capture_move.from)
      capture_to = Position.new_from_int(capture_move.to)

      black_capture_pos = Position.new_from_int(Position::BLACK_CAPTURE_INT)

      expect(capture_from.equals?(destination)).to eq true
      expect(capture_to.equals?(black_capture_pos)).to eq true


      # Check that the piece was moved to the destination
      move = inserted[1]
      move_from = Position.new_from_int(move.from)
      move_to = Position.new_from_int(move.to)

      expect(move_from.equals?(orig_pos)).to eq true
      expect(move_to.equals?(destination)).to eq true

    end

    it "alerts the user of a bad move if the move is not valid or is obstructed" do
      # perform checks

      # alert user

      # no changes

    end
  end

end
