require 'rspec'
require 'rails_helper'

RSpec.describe "Rook" do

  describe 'rook#is_valid' do
    it "checks that a move actually contains movement" do
      rook = Rook.new(:black, Position.new(4, 4))
      destination = Position.new(4, 4)

      expect(rook.is_valid?(destination)).to eq(false)
    end

    it "checks that a rook can't move diagonally" do
      rook = Rook.new(:black, Position.new(4, 4))
      destination1 = Position.new(7, 7)
      destination2 = Position.new(1, 1)
      destination3 = Position.new(3, 5)
      destination4 = Position.new(5, 3)

      expect(rook.is_valid?(destination1)).to eq(false)
      expect(rook.is_valid?(destination2)).to eq(false)
      expect(rook.is_valid?(destination3)).to eq(false)
      expect(rook.is_valid?(destination4)).to eq(false)
    end

    it "checks that a rook can move up or down" do
      rook = Rook.new(:black, Position.new(4, 4))
      destination1 = Position.new(4, 7)
      destination2 = Position.new(4, 1)
      destination3 = Position.new(4, 5)
      destination4 = Position.new(4, 3)

      expect(rook.is_valid?(destination1)).to eq(true)
      expect(rook.is_valid?(destination2)).to eq(true)
      expect(rook.is_valid?(destination3)).to eq(true)
      expect(rook.is_valid?(destination4)).to eq(true)
    end

    it "checks that a rook can move left or right" do
      rook = Rook.new(:black, Position.new(4, 4))
      destination1 = Position.new(1, 4)
      destination2 = Position.new(7, 4)
      destination3 = Position.new(5, 4)
      destination4 = Position.new(3, 4)

      expect(rook.is_valid?(destination1)).to eq(true)
      expect(rook.is_valid?(destination2)).to eq(true)
      expect(rook.is_valid?(destination3)).to eq(true)
      expect(rook.is_valid?(destination4)).to eq(true)
    end

    it "checks that a rook can't move off the board" do

      rook = Rook.new(:black, Position.new(4, 4))
      destination1 = Position.new(10, 4)
      destination2 = Position.new(4, -5)
      destination3 = Position.new(50, 4)
      destination4 = Position.new(-16, 4)

      expect(rook.is_valid?(destination1)).to eq(false)
      expect(rook.is_valid?(destination2)).to eq(false)
      expect(rook.is_valid?(destination3)).to eq(false)
      expect(rook.is_valid?(destination4)).to eq(false)
    end

    it "checks the positions for the obstruction tests" do
      rook = Rook.new(:white, Position.new(5, 0))
      destination = Position.new(1, 0)

      expect(rook.is_valid?(destination)).to eq true
    end
  end

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
      destination = Position.new(1, 0)
      pieces = [rook, ChessPiece.new(:black, destination)]

      expect(rook.is_obstructed?(pieces, destination)).to eq false
    end

    it 'determines a piece of same color is an obstruction' do
      rook = Rook.new(:white, Position.new(5, 0))
      destination = Position.new(1, 0)
      pieces = [rook, ChessPiece.new(:white, Position.new(2, 0))]

      expect(rook.is_obstructed?(pieces, destination)).to eq true
    end

    it 'determines a piece of opposite color is an obstruction' do
      rook = Rook.new(:white, Position.new(5, 0))
      destination = Position.new(1, 0)
      pieces = [rook, ChessPiece.new(:black, Position.new(2, 0))]

      expect(rook.is_obstructed?(pieces, destination)).to eq true
    end
  end
end
