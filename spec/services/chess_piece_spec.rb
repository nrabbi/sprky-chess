require 'rspec'
require 'rails_helper'

describe 'Chess Piece' do

  describe 'chess_piece#can_capture?' do
    it 'checks if a square with a piece can be captured' do
      piece = ChessPiece.new(:white, Position.new(2, 3))
      capture_position = Position.new(5, 6)
      capture_piece = ChessPiece.new(:black, capture_position)

      pieces = [capture_piece]

      expect(piece.can_capture?(pieces, capture_position)).to eq true
      expect(piece.can_capture?(pieces, Position.new(1, 2))).to eq false # empty square

    end

    it "checks that a piece can't capture it's own color" do
      piece = ChessPiece.new(:white, Position.new(2, 3))
      capture_position = Position.new(5, 6)
      capture_piece = ChessPiece.new(:white, capture_position)

      pieces = [capture_piece]

      expect(piece.can_capture?(pieces, capture_position)).to eq false
    end
  end

end
