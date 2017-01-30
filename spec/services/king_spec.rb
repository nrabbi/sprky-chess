require 'rspec'
require 'rails_helper'

RSpec.describe "King" do
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
