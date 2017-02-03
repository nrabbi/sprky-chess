require 'rspec'
require 'rails_helper'

RSpec.describe "King" do

  describe "king#is_valid" do
    it "checks that a king can't move more than 1 square" do
      king = King.new(:white, Position.new(3, 3))
      destination1 = Position.new(3,5)
      destination2 = Position.new(5,3)
      destination3 = Position.new(5,5)
      destination4 = Position.new(1,3)
      destination5 = Position.new(3,1)
      destination6 = Position.new(1,1)
      destination7 = Position.new(5,1)
      destination8 = Position.new(1,5)

      expect(king.is_valid?(destination1)).to eq(false)
      expect(king.is_valid?(destination2)).to eq(false)
      expect(king.is_valid?(destination3)).to eq(false)
      expect(king.is_valid?(destination4)).to eq(false)
      expect(king.is_valid?(destination5)).to eq(false)
      expect(king.is_valid?(destination6)).to eq(false)
      expect(king.is_valid?(destination7)).to eq(false)
      expect(king.is_valid?(destination8)).to eq(false)
    end

    it "checks that a king can move 1 square in any directions" do
      king = King.new(:white, Position.new(3, 3))
      destination1 = Position.new(3,4)
      destination2 = Position.new(3,2)
      destination3 = Position.new(4,3)
      destination4 = Position.new(2,4)
      destination5 = Position.new(2,2)
      destination6 = Position.new(4,4)
      destination7 = Position.new(4,2)
      destination8 = Position.new(2,3)

      expect(king.is_valid?(destination1)).to eq(true)
      expect(king.is_valid?(destination2)).to eq(true)
      expect(king.is_valid?(destination3)).to eq(true)
      expect(king.is_valid?(destination4)).to eq(true)
      expect(king.is_valid?(destination5)).to eq(true)
      expect(king.is_valid?(destination6)).to eq(true)
      expect(king.is_valid?(destination7)).to eq(true)
      expect(king.is_valid?(destination8)).to eq(true)
    end

    it "checks that a king can't move off the board" do

      king = King.new(:black, Position.new(4,4))
      destination1 = Position.new(10,4)
      destination2 = Position.new(4,-5)
      destination3 = Position.new(50,4)
      destination4 = Position.new(-16,4)

      expect(king.is_valid?(destination1)).to eq(false)
      expect(king.is_valid?(destination2)).to eq(false)
      expect(king.is_valid?(destination3)).to eq(false)
      expect(king.is_valid?(destination4)).to eq(false)
    end

  end

  describe 'king#is_obstructed' do # Assuming move is valid

    it 'checks that a king moves only 1 square' do

      king = King.new(:white, Position.new(3, 3))
      pieces = [king]
      destination = Position.new(2, 5)
      expect(king.is_obstructed?(pieces, destination)).to eq(true)

    end

    it 'checks that a king cant move off the board' do

      king = King.new(:white, Position.new(0, 0))
      pieces = [king]
      destination = Position.new(-1, -1)
      expect(king.is_obstructed?(pieces, destination)).to eq(true)

      king = King.new(:white, Position.new(7, 0))
      pieces = [king]
      destination = Position.new(8, 0)
      expect(king.is_obstructed?(pieces, destination)).to eq(true)

      king = King.new(:white, Position.new(0, 7))
      pieces = [king]
      destination = Position.new(0, 8)
      expect(king.is_obstructed?(pieces, destination)).to eq(true)

      king = King.new(:white, Position.new(7, 7))
      pieces = [king]
      destination = Position.new(8, 8)
      expect(king.is_obstructed?(pieces, destination)).to eq(true)

    end

    it 'determines that a piece is between a king and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,D,0,0,0,0,0 --> Destination is occupied
      # 0,0,0,K,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      king = King.new(:white, Position.new(3, 3))
      obstructor_piece0 = Pawn.new(:white, Position.new(2, 4))
      obstructor_piece1 = Pawn.new(:white, Position.new(2, 2))
      pieces = [king, obstructor_piece0, obstructor_piece1]
      destination = Position.new(2, 4)
      expect(king.is_obstructed?(pieces, destination)).to eq(true)

    end

    it 'determines that there is nothing between a king and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,K,x,0,0,0 --> Destination is occupied
      # 0,0,0,x,D,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      king = King.new(:white, Position.new(3, 3))
      destination = Position.new(4, 2)
      pieces = [king, Pawn.new(:white, Position.new(3, 2)), Pawn.new(:white, Position.new(4, 3))]

      expect(king.is_obstructed?(pieces, destination)).to eq(false)
    end
  end
end
