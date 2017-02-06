require 'rspec'
require 'rails_helper'

RSpec.describe "Queen" do
  describe 'queen#is_obstructed' do # Assuming move is valid

    it 'determines that a piece is between a queen and a square' do
      pending("Queen is_obstructed? method is awaiting implementation")
      # 0,0,D,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,x,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,Q,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      queen = Queen.new(2, 2)
      destination = Position.new(2, 7)
      obstructor_piece = ChessPiece.new(2, 5)
      pieces = [queen, obstructor_piece]
      expect(queen.is_obstructed?(pieces, destination)).to eq true

      # MORE TEST CASES SHOULD BE ADDED

    end

    it 'determines that there is nothing between a queen and a square' do
      pending("Queen is_obstructed? method is awaiting implementation")
      # 0,0,0,0,0,0,x,D
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,Q,x,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      queen = Queen.new(2, 2)
      destination = Position.new(7, 7)
      pieces = [queen, ChessPiece.new(3, 2), ChessPiece.new(3, 4), ChessPiece.new(6, 7)]

      expect(queen.is_obstructed?(pieces, destination)).to eq false
    end
  end

  describe 'queen#is_valid?' do
    it 'checks that destination is not same as origin' do
      queen = Queen.new(:white, Position.new(3, 0))
      destination = Position.new(3, 0)

      expect(queen.is_valid?(destination)).to eq(false)
    end

    it 'checks that a queen cannot move off the board' do
      queen = Queen.new(:white, Position.new(3, 0))
      destination1 = Position.new(10, 4)
      destination2 = Position.new(4, -5)
      destination3 = Position.new(50, 4)
      destination4 = Position.new(-16, 4)

      expect(queen.is_valid?(destination1)).to eq(false)
      expect(queen.is_valid?(destination2)).to eq(false)
      expect(queen.is_valid?(destination3)).to eq(false)
      expect(queen.is_valid?(destination4)).to eq(false)
    end

    it 'checks that a queen can move horizontally' do
      queen = Queen.new(:white, Position.new(4, 4))
      destination1 = Position.new(0, 4)
      destination2 = Position.new(7, 4)
      destination3 = Position.new(5, 4)
      destination4 = Position.new(3, 4)

      expect(queen.is_valid?(destination1)).to eq(true)
      expect(queen.is_valid?(destination2)).to eq(true)
      expect(queen.is_valid?(destination3)).to eq(true)
      expect(queen.is_valid?(destination4)).to eq(true)
    end

    it 'checks that a queen can move vertically' do
      queen = Queen.new(:white, Position.new(4, 4))
      destination1 = Position.new(4,7)
      destination2 = Position.new(4,0)
      destination3 = Position.new(4,5)
      destination4 = Position.new(4,3)

      expect(queen.is_valid?(destination1)).to eq(true)
      expect(queen.is_valid?(destination2)).to eq(true)
      expect(queen.is_valid?(destination3)).to eq(true)
      expect(queen.is_valid?(destination4)).to eq(true)
    end

    it 'checks that a queen can move diagonally' do
      start_x = 3
      start_y = 3
      queen = Queen.new(:white, Position.new(3, 3))
      
      destination1 = Position.new(start_x + 1, start_y + 1)
      destination2 = Position.new(start_x + 3, start_y + 3)
      destination3 = Position.new(start_x - 2, start_y + 2)
      destination4 = Position.new(start_x + 1, start_y - 1)
      destination5 = Position.new(start_x - 3, start_y - 3)


      expect(queen.is_valid?(destination1)).to eq(true)
      expect(queen.is_valid?(destination2)).to eq(true)
      expect(queen.is_valid?(destination3)).to eq(true)
      expect(queen.is_valid?(destination4)).to eq(true)
      expect(queen.is_valid?(destination5)).to eq(true)
    end

    it 'checks that a queen cannot move arbitrarily' do
      queen = Queen.new(:white, Position.new(3, 3))
      destination1 = Position.new(4, 7)
      destination2 = Position.new(2, 0)
      destination3 = Position.new(0, 2)
      destination4 = Position.new(7, 4)

      expect(queen.is_valid?(destination1)).to eq(false)
      expect(queen.is_valid?(destination2)).to eq(false)
      expect(queen.is_valid?(destination3)).to eq(false)
      expect(queen.is_valid?(destination4)).to eq(false)
    end
  end
end
