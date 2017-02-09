require 'rspec'
require 'rails_helper'

RSpec.describe "Queen" do
  describe 'queen#is_obstructed' do # Assuming move is valid

    it 'determines that a piece is between a queen and a square' do
      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,Q,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      queen = Queen.new(:white, Position.new(2, 2))
      destination = Position.new(2, 7)
      obstructor_piece = Pawn.new(:white, Position.new(2, 5))
      pieces = [queen, obstructor_piece]
      expect(queen.is_obstructed?(pieces, destination)).to eq true

      # MORE TEST CASES SHOULD BE ADDED

    end

    it 'determines that there is nothing between a queen and a square' do
      # 0,0,0,0,0,0,x,D
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,Q,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      queen = Queen.new(:white, Position.new(2, 2))
      destination = Position.new(7, 7)
      pieces = [queen, Pawn.new(:white, Position.new(3, 2)), Pawn.new(:white, Position.new(3, 4)), Pawn.new(:white, Position.new(6, 7))]

      expect(queen.is_obstructed?(pieces, destination)).to eq false
    end

    it 'determines a piece of opposite color at the destination is not an obstruction' do
      queen = Queen.new(:white, Position.new(5, 0))
      destination = Position.new(2, 0)
      pieces = [queen, ChessPiece.new(:black, destination)]

      expect(queen.is_obstructed?(pieces, destination)).to eq false
    end
  end

end