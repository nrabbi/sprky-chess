require 'rspec'
require 'rails_helper'

RSpec.describe "Bishop" do
  describe 'bishop#is_obstructed' do   # Assuming move is valid

    it 'should determine that a piece is between a bishop and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,D
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,B,0,0,0,0,0

      # 1 obstruction
      bishop = Bishop.new(:white, Position.new(2,0))
      obstructor_piece = Pawn.new(:white, Position.new(5, 3))
      pieces = [bishop, obstructor_piece]
      destination = Position.new(7,5)
      expect(bishop.is_obstructed?(pieces, destination)).to eq true

      # 2 obstructions
      obstructor_piece_2 = Pawn.new(:white, Position.new(3, 1))
      pieces << obstructor_piece_2
      expect(bishop.is_obstructed?(pieces, destination)).to eq true
    end

    it 'should determine that there is nothing between a bishop and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,P,P,0,0,0,0,0
      # 0,P,D,P,0,0,0,0
      # 0,0,P,0,P,0,0,0
      # 0,0,0,P,0,P,0,0
      # 0,0,0,0,0,B,0,0

      # No obstruction
      bishop = Bishop.new(:white, Position.new(5, 0))
      pieces = [bishop, Pawn.new(:white, Position.new(1, 3)), Pawn.new(:white, Position.new(1, 4)), Pawn.new(:white, Position.new(2, 2)), Pawn.new(:white, Position.new(2, 4)),
                Pawn.new(:white, Position.new(3, 1)), Pawn.new(:white, Position.new(3, 3)), Pawn.new(:white, Position.new(4, 2)), Pawn.new(:white, Position.new(5, 1))]
      destination = Position.new(2, 3)

      expect(bishop.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
