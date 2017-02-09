require 'rspec'
require 'rails_helper'

RSpec.describe "Rook" do
  describe 'rook#is_obstructed' do # Assuming move is valid

    it 'determines that a piece is between a rook and a square' do

      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,R,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      rook = Rook.new(:white, Position.new(2, 2))
      destination = Position.new(2, 7)
      obstructor_piece = Pawn.new(:white, Position.new(2, 5))
      pieces = [rook, obstructor_piece]
      expect(rook.is_obstructed?(pieces, destination)).to eq true

    end

    it 'determines that there is nothing between a rook and a square' do

      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,R,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      rook = Rook.new(:white, Position.new(2, 2))
      destination = Position.new(2, 7)
      pieces = [rook, Pawn.new(:white, Position.new(2, 1)), Pawn.new(:white, Position.new(3, 4))]

      expect(rook.is_obstructed?(pieces, destination)).to eq false
    end

    it 'determines a piece of opposite color at the destination is not an obstruction' do
      rook = Rook.new(:white, Position.new(5, 0))
      destination = Position.new(2, 3)
      pieces = [rook, ChessPiece.new(:black, destination)]

      expect(rook.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
