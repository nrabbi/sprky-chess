require 'rspec'
require 'rails_helper'

RSpec.describe "Bishop" do
  
  describe 'bishop#is_valid' do
    it 'checks that a move actually contains movement' do

      bishop = Bishop.new(:black, Position.new(4,4))
      destination = Position.new(4,4)

      expect(bishop.is_valid?(destination)).to eq(false)
    end

    it 'checks that a bishop does not move off the board' do

      bishop = Bishop.new(:black, Position.new(4,4))
      destination1 = Position.new(10,4)
      destination2 = Position.new(4,-5)
      destination3 = Position.new(50,4)
      destination4 = Position.new(-16,4)

      expect(bishop.is_valid?(destination1)).to eq(false)
      expect(bishop.is_valid?(destination2)).to eq(false)
      expect(bishop.is_valid?(destination3)).to eq(false)
      expect(bishop.is_valid?(destination4)).to eq(false)

    end
    
    it 'checks that a bishop can move diagonally' do
      start_x = 3
      start_y = 3
      bishop = Bishop.new(:black, Position.new(start_x, start_y))
      
      destination1 = Position.new(start_x + 1, start_y + 1)
      destination2 = Position.new(start_x + 3, start_y + 3)
      destination3 = Position.new(start_x - 2, start_y + 2)
      destination4 = Position.new(start_x + 1, start_y - 1)
      destination5 = Position.new(start_x - 3, start_y - 3)


      expect(bishop.is_valid?(destination1)).to eq(true)
      expect(bishop.is_valid?(destination2)).to eq(true)
      expect(bishop.is_valid?(destination3)).to eq(true)
      expect(bishop.is_valid?(destination4)).to eq(true)
      expect(bishop.is_valid?(destination5)).to eq(true)
    end
    
    it "checks that a bishop can't move vertically or horizontally" do
      start_x = 3
      start_y = 3
      bishop = Bishop.new(:black, Position.new(start_x, start_y))

      destination1 = Position.new(start_x, start_y - 1)
      destination2 = Position.new(start_x, start_y + 3)
      destination3 = Position.new(start_x - 2, start_y)
      destination4 = Position.new(start_x + 1, start_y)
      destination5 = Position.new(start_x - 3, start_y)


      expect(bishop.is_valid?(destination1)).to eq(false)
      expect(bishop.is_valid?(destination2)).to eq(false)
      expect(bishop.is_valid?(destination3)).to eq(false)
      expect(bishop.is_valid?(destination4)).to eq(false)
      expect(bishop.is_valid?(destination5)).to eq(false)
    end
  end
  
  describe 'bishop#is_obstructed' do # Assuming move is valid

    it 'determines that a piece is between a bishop and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,D
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,P,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,P,0,0,0,0
      # 0,0,B,0,0,0,0,0

      # 1 obstruction
      bishop = Bishop.new(:white, Position.new(2, 0))
      obstructor_piece = Pawn.new(:white, Position.new(5, 3))
      pieces = [bishop, obstructor_piece]
      destination = Position.new(7, 5)
      expect(bishop.is_obstructed?(pieces, destination)).to eq true

      # 2 obstructions
      obstructor_piece_2 = Pawn.new(:white, Position.new(3, 1))
      pieces << obstructor_piece_2
      expect(bishop.is_obstructed?(pieces, destination)).to eq true
    end

    it 'determines that there is nothing between a bishop and a square' do

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

    it 'determines a piece of opposite color at the destination is not an obstruction' do
      bishop = Bishop.new(:white, Position.new(5, 0))
      destination = Position.new(2, 3)
      pieces = [bishop, ChessPiece.new(:black, destination)]

      expect(bishop.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
