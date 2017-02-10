require 'rspec'
require 'rails_helper'

RSpec.describe "Knight" do

  describe 'knight#is-valid' do

    it 'checks that a move actually contains movement' do

      knight = Knight.new(:black, Position.new(4, 4))
      destination = Position.new(4, 4)

      expect(knight.is_valid?(destination)).to eq(false)
    end

    it 'checks that a knight does not move off the board' do

      knight = Knight.new(:black, Position.new(4, 4))
      destination1 = Position.new(10, 4)
      destination2 = Position.new(4, -5)
      destination3 = Position.new(50, 4)
      destination4 = Position.new(-16, 4)

      expect(knight.is_valid?(destination1)).to eq(false)
      expect(knight.is_valid?(destination2)).to eq(false)
      expect(knight.is_valid?(destination3)).to eq(false)
      expect(knight.is_valid?(destination4)).to eq(false)

    end

    it 'checks that a knight can move in an L-shape' do
      start_x = 3
      start_y = 3
      knight = Knight.new(:black, Position.new(start_x, start_y))
      m1 = 1
      m2 = 2

      # L-shape in all directions
      destination1 = Position.new(start_x + m1, start_y + m2)
      destination2 = Position.new(start_x - m1, start_y + m2)
      destination3 = Position.new(start_x - m1, start_y - m2)
      destination4 = Position.new(start_x + m1, start_y - m2)

      destination5 = Position.new(start_x + m2, start_y + m1)
      destination6 = Position.new(start_x - m2, start_y + m1)
      destination7 = Position.new(start_x - m2, start_y - m1)
      destination8 = Position.new(start_x + m2, start_y - m1)

      expect(knight.is_valid?(destination1)).to eq(true)
      expect(knight.is_valid?(destination2)).to eq(true)
      expect(knight.is_valid?(destination3)).to eq(true)
      expect(knight.is_valid?(destination4)).to eq(true)
      expect(knight.is_valid?(destination5)).to eq(true)
      expect(knight.is_valid?(destination6)).to eq(true)
      expect(knight.is_valid?(destination7)).to eq(true)
      expect(knight.is_valid?(destination8)).to eq(true)
    end

    it "checks that a knight can't move in any other way than an L-shape" do
      start_x = 3
      start_y = 3
      knight = Knight.new(:black, Position.new(start_x, start_y))

      # Non-L-shape Movements
      destination1 = Position.new(start_x + 3, start_y)
      destination2 = Position.new(start_x + 3, start_y + 1)
      destination3 = Position.new(start_x + 1, start_y + 3)
      destination4 = Position.new(start_x, start_y + 2)
      destination5 = Position.new(start_x, start_y - 1)
      destination6 = Position.new(start_x - 3, start_y - 1)

      expect(knight.is_valid?(destination1)).to eq(false)
      expect(knight.is_valid?(destination2)).to eq(false)
      expect(knight.is_valid?(destination3)).to eq(false)
      expect(knight.is_valid?(destination4)).to eq(false)
      expect(knight.is_valid?(destination5)).to eq(false)
      expect(knight.is_valid?(destination6)).to eq(false)
    end
  end

  describe 'knight#is_obstructed' do # Assuming move is valid

    it 'determines that a piece is between a knight and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,D,0,0,0,0 --> Destination is occupied
      # 0,0,0,0,0,0,0,0
      # 0,0,K,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0

      knight = Knight.new(:white, Position.new(2, 2))
      destination = Position.new(3, 4)
      obstructor_piece = Pawn.new(:white, Position.new(3, 4))
      pieces = [knight, obstructor_piece]
      expect(knight.is_obstructed?(pieces, destination)).to eq true

    end

    it 'determines that there is nothing between a knight and a square' do

      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,0,0,0,0,0,0
      # 0,0,K,x,0,0,0,0
      # 0,0,x,x,0,0,0,0
      # 0,0,x,D,0,0,0,0 --> Destination is unoccupied
      # 0,0,0,0,0,x,0,0
      # 0,0,0,0,0,0,0,0

      # No obstruction
      knight = Knight.new(:white, Position.new(2, 4))
      destination = Position.new(3, 2)
      pieces = [knight, Pawn.new(:white, Position.new(2, 2)), Pawn.new(:white, Position.new(2, 3)), Pawn.new(:white, Position.new(3, 3)), Pawn.new(:white, Position.new(3, 4)),
                Pawn.new(:white, Position.new(5, 1))]

      expect(knight.is_obstructed?(pieces, destination)).to eq false
    end
  end
end
